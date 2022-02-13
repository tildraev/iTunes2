//
//  ResultError.swift
//  iTunes
//
//  Created by Arian Mohajer on 2/13/22.
//

import Foundation

enum ResultError: LocalizedError {
    
    //This one takes in a url string so that we can use that in the error message
    case invalidURL(String)
    
    //Datatask and JSON can throw errors
    case thrownError(Error)
    
    //Error if there is no data
    case noData
    
    //If JSONDecoder is unable to successfully finish task
    case unableToDecode
    
    //Each error gets a respective errorDescription, as a String, that we can use for debugging purposes
    var errorDescription: String? {
        switch self {
            
        case .invalidURL:
            return "Unable to reach the server. Please try again."
        case .thrownError(let error):
            return "Error: \(error.localizedDescription) -> \(error)"
        case .noData:
            return "The server responded with no data. Please try again."
        case .unableToDecode:
            return "The server responded with bad data. Please try again."
        }
    }
}
