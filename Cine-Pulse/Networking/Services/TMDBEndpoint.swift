//
//  TMDBEndpoint.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 04.10.25.
//

import Foundation

enum TMDBEndpoint: Endpoint{
    case movieList(query: String? = nil, page: Int = 1)
    case movieDetails(id: Int)
    case movieCredits(id: Int)
    
    
    var baseURL: String{
        return "https://api.themoviedb.org"
    }
    
    var path: String{
        switch self{
        case .movieList(let query, _):
            if let _ = query{
                return "/3/search/movie"
            }else{
                return "/3/movie/popular"
            }
        case .movieDetails(let id):
            return "/3/movie/\(id)"
        case .movieCredits(let id):
            return "/3/movie/\(id)/credits"
        }
    }
    
    var method: HTTPMethod{
        return .get
    }
    
    var headers: [String: String]? {
        ["Authorization": "Bearer \(Secrets.tmdbAccessToken)"]
    }
    
    var queryItems: [URLQueryItem]? {
        switch self{
        case .movieList(let query, let page):
            var items: [URLQueryItem] = [
                URLQueryItem(name: "page", value: "\(page)")
            ]
            
            if let q = query, !q.isEmpty{
                items.append(URLQueryItem(name: "query", value: q))
            }
            
            return items
        default:
            return nil
        }
    }
}
