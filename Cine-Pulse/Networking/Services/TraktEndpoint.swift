//
//  TraktEndpoint.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 26.10.25.
//

import Foundation

enum TraktEndpoint: Endpoint{
    case movieRating(imdbID: String)
    
    var baseURL: String{
        return "https://api.trakt.tv"
    }
    
    var path: String{
        switch self {
        case .movieRating(let imdbID):
            return "/movies/\(imdbID)/ratings"
        }
    }
    
    var method: HTTPMethod{
        return .get
    }
    
    var headers: [String : String]? {
        guard let clinetID = Secrets.traktClientID else{
            fatalError("Trakt client ID is not set")
        }
        
        return [
            "Content-Type": "application/json",
            "trakt-api-version": "2",
            "trakt-api-key": "\(clinetID)"
        ]
    }
}
