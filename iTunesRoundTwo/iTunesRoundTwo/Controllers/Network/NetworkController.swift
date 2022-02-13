//
//  NetworkController.swift
//  iTunes
//
//  Created by Arian Mohajer on 2/13/22.
//

import Foundation

class NetworkController {
    private static let baseURL = URL(string: "https://itunes.apple.com")
    
    static func fetchAlbums(searchTerm: String, completion: @escaping (Result<TopLevelDictionary, ResultError>) -> Void) {
        
        guard let baseURL = baseURL else {
            completion(.failure(.invalidURL(baseURL?.absoluteString ?? "")))
            return
        }
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        urlComponents?.path = "/search"
        
        let mediaQueryItem = URLQueryItem(name: "media", value: "music")
        let termQueryItem = URLQueryItem(name: "term", value: searchTerm)
        let entityQueryItem = URLQueryItem(name: "entity", value: "album")
        
        urlComponents?.queryItems = [termQueryItem, mediaQueryItem,entityQueryItem]
        
        guard let finalURL = urlComponents?.url else {
            completion(.failure(.invalidURL(urlComponents?.url?.absoluteString ?? "")))
            return
        }
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedTopLevelDictionary = try JSONDecoder().decode(TopLevelDictionary.self, from: data)
                completion(.success(decodedTopLevelDictionary))
            } catch {
                completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchSongList(collectionID: Int, completion: @escaping (Result<TopLevelDictionary, ResultError>) -> Void) {
        guard let finalURL = URL(string: "https://itunes.apple.com/lookup?id=\(collectionID)&entity=song") else {
            completion(.failure(.invalidURL("")))
            return
        }
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedTopLevelDictionary = try JSONDecoder().decode(TopLevelDictionary.self, from: data)
                completion(.success(decodedTopLevelDictionary))
            } catch {
                completion(.failure(.unableToDecode))
            }

        }.resume()
    }
}
