//
//  SelectedMovies.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 18.10.25.
//

import Foundation
protocol SelectedMovies{
    var movie: [MovieListModel.Movie]   { get set }
}

extension SelectedMovies{
    func movie(at index: Int) -> MovieListModel.Movie? {
        guard movie.indices.contains(index) else {
            return nil
        }
        return movie[index]
    }
}
