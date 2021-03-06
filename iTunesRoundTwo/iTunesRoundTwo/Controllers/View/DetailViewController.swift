//
//  DetailViewController.swift
//  iTunesRoundTwo
//
//  Created by Arian Mohajer on 2/13/22.
//

import UIKit

class DetailViewController: UIViewController {

    var topLevelDictionary: TopLevelDictionary? {
        didSet {
            for song in topLevelDictionary!.results {
                if song.kind == "song" {
                    songList.append(song.trackName ?? "")
                    if let songMS = song.trackTimeMillis {
                        runTimes.append(songMS/1000)
                    }
                }
            }
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    var songList: [String] = []
    var runTimes: [Int] = []
    
    @IBOutlet weak var songListTableView: UITableView!
    @IBOutlet weak var albumNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songListTableView.delegate = self
        songListTableView.dataSource = self
    }
    
    func updateViews() {
        albumNameLabel.text = topLevelDictionary?.results[0].collectionName
        songListTableView.reloadData()
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        
        cell.textLabel?.text = songList[indexPath.row]
        cell.detailTextLabel?.text = formatTime(seconds: runTimes[indexPath.row])
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func formatTime(seconds: Int) -> String {
        let minutes: Int = seconds/60
        let seconds = seconds%60
        return seconds < 10 ? "\(minutes):0\(seconds)" : "\(minutes):\(seconds)"
    }
}
