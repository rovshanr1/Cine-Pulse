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
    case movieVideos(id: Int)
    case topRated(page: Int = 1)
    case upcoming(page: Int = 1)
    case personDetails(id: Int)
    case personCombinedCredits(id: Int)
    
    
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
        case .movieVideos(id: let id):
            return "/3/movie/\(id)/videos"
        case .personDetails(id: let id):
            return "/3/person/\(id)"
        case .personCombinedCredits(id: let id):
            return "/3/person/\(id)/combined_credits"
        case .topRated:
            return "/3/movie/top_rated"
        case .upcoming:
            return "/3/movie/upcoming"
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
            
        case .topRated(let page), .upcoming(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        default:
            return nil
        }
    }
}
