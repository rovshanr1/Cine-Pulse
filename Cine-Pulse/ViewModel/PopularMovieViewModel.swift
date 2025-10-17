//
//  PopularMovieViewModel.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 09.10.25.
//

import Foundation
import Combine

final class PopularMovieViewModel: BaseViewModel, SelectedMovies{
    @Published var movieList: [MovieListModel.Movie] = []
    
    private var currentPage: Int = 1
    private var totalPages: Int = 1

    
    func fetchInitialMovies() {
        movieList.removeAll()
        currentPage = 1
        totalPages = 1
        fetchNextPage()
    }
    
    func fetchNextPage() {
        guard !isLoading, currentPage <= totalPages else { return }
        let endpoint = TMDBEndpoint.movieList(query: nil, page: currentPage)
        
      
        super.fetchData(from: endpoint) { [weak self] (response: MovieListModel) in
            guard let self = self else { return }
            
            self.movieList.append(contentsOf: response.results)
            self.currentPage += 1
            self.totalPages = response.totalPages
        }
    }
}
