//
//  HomeViewModel.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 09.10.25.
//

import Foundation
import Combine

final class HomeViewModel: BaseViewModel, SelectedMovies {
    @Published var movie: [MovieListModel.Movie] = []
    @Published var topRatedMovies: [MovieListModel.Movie] = []
    @Published var upcomingMovies: [MovieListModel.Movie] = []
    
    func fetchPopularMovies(query: String? = nil, page: Int = 1) {
        let endpoint = TMDBEndpoint.movieList(query: query, page: page)
        
        super.fetchData(from: endpoint) { [weak self] (response: MovieListModel) in
            guard let self = self else { return }
            self.movie = response.results
        }
    }
    
    func fetchTopRatedMovies(page: Int = 1) {
        let endpoint = TMDBEndpoint.topRated(page: page)
        
        super.fetchData(from: endpoint) { [weak self] (response: MovieListModel) in
            guard let self = self else { return }
            self.topRatedMovies = response.results
        }
    }
    
    func fetchUpcomingMovies(page: Int = 1) {
        let endpoint = TMDBEndpoint.upcoming(page: page)
        
        super.fetchData(from: endpoint) { [weak self] (response: MovieListModel) in
            guard let self = self else { return }
            self.upcomingMovies = response.results
        }
    }
    
   
    func movie(category: MovieCategory,at index: Int) -> MovieListModel.Movie? {
        guard index < movie.count else { return nil }
        return movie[index]
    }
    
}
