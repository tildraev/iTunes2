//
//  SearchAlbumTableViewController.swift
//  iTunes
//
//  Created by Arian Mohajer on 2/13/22.
//

import UIKit

class SearchAlbumTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var topLevelDictionary: TopLevelDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let topLevelDictionary = topLevelDictionary else {
            return 0
        }
        
        return topLevelDictionary.results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as? AlbumTableViewCell else { return UITableViewCell() }
        
        guard let topLevelDictionary = topLevelDictionary else {
            return cell
        }
        
        
        // Configure the cell...
        cell.albumNameLabel.text = topLevelDictionary.results[indexPath.row].collectionName
        cell.albumSongCountLabel.text = "Tracks: \(topLevelDictionary.results[indexPath.row].trackCount)"
        
        NetworkController.fetchCoverArt(artworkURL: topLevelDictionary.results[indexPath.row].artworkUrl100) { result in
            switch result {
                
            case .success(let coverArt):
                DispatchQueue.main.async {
                    cell.albumCoverArtImageView.image = coverArt
                }
            case .failure(let error):
                print(error)
            }
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let index = tableView.indexPathForSelectedRow {
                if let destination = segue.destination as? DetailViewController {
                    guard let topLevelDictionary = topLevelDictionary else {
                        return
                    }
                    
                    NetworkController.fetchSongList(collectionID: topLevelDictionary.results[index.row].collectionId) { result in
                        switch result {
                            
                        case .success(let tld):
                            destination.topLevelDictionary = tld
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        }
    }
}

extension SearchAlbumTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchTerm = searchBar.text else {
            return
        }
        NetworkController.fetchAlbums(searchTerm: searchTerm) { result in
            switch result {
                
            case .success(let topLevelDictionary):
                self.topLevelDictionary = topLevelDictionary
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
