//
//  MovieListModel.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 05.10.25.
//

import Foundation

struct MovieListModel: Codable, Equatable{
    let results: [Movie]
    let page: Int
    let totalPages: Int
    let totalResults: Int
    
    struct Movie: Codable, Equatable{
        let id: Int
        let adult: Bool
        let title: String
        let overview: String
        let posterPath: String?
        let backdropPath: String?
        let releaseDate: String?
        let voteAverage: Double
        let voteCount: Int
    }
}

extension MovieListModel.Movie: Identifiable {
    var posterURL: URL? {.tmdbImage(path: posterPath)}
}
