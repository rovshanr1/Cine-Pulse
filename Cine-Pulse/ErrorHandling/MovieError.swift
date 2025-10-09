//
//  MovieError.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 09.10.25.
//

import Foundation

enum MovieError: LocalizedError, Error{
    case failToFetchMovies
    
    
    var errorDescription: String? {
        switch self {
        case .failToFetchMovies:
            return "Failed to fetch movies"
        }
    }
}
