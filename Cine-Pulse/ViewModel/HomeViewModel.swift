//
//  HomeViewModel.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 09.10.25.
//

import Foundation
import Combine

final class HomeViewModel: BaseViewModel, SelectedMovies {
    @Published var movieList: [MovieListModel.Movie] = []
    
    func fetchMovies(query: String? = nil, page: Int = 1) {
        let endpoint = TMDBEndpoint.movieList(query: query, page: page)
        
        super.fetchData(from: endpoint) { [weak self] (response: MovieListModel) in
            guard let self = self else { return }
            self.movieList = response.results
        }
    }
}
