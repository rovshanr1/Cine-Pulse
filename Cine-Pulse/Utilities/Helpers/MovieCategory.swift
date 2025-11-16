//
//  MovieCategory.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 28.10.25.
//

import Foundation

enum MovieCategory{
    case popularMovie
    case topRated
    case upcoming
    
    var displayTitle: String {
        switch self {
        case .popularMovie:
            return "Popular Movies"
        case .topRated:
            return "Top Rated"
        case .upcoming:
            return "Upcoming"
        }
    }
    
    func endpint(page: Int) -> TMDBEndpoint{
        switch self{
        case .popularMovie:
            return TMDBEndpoint.movieList(query: nil, page: page)
        case .topRated:
            return TMDBEndpoint.topRated(page: page)
        case .upcoming:
            return TMDBEndpoint.upcoming(page: page)
        }
    }
}
