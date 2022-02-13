//
//  Results.swift
//  iTunes
//
//  Created by Arian Mohajer on 2/13/22.
//

import Foundation

struct TopLevelDictionary: Decodable {
    var resultCount: Int
    var results: [SearchResult]
}

struct SearchResult: Decodable {
    var artistId: Int
    var collectionId: Int
    var artistName: String
    var collectionName: String
    var artworkUrl100: String
    var trackCount: Int
    var trackName: String?
    var kind: String?
}
