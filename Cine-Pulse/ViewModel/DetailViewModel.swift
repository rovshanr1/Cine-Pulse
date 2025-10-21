//
//  DetailViewModel.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 17.10.25.
//

import Foundation
import Combine

final class DetailViewModel: BaseViewModel{
    @Published var movieDetails: MovieDetailModel?
    @Published var movieCredits: MovieCreditsModel?

    
    func fetchMovieDetails(id: Int){
        let endpoint = TMDBEndpoint.movieDetails(id: id)
        
        super.fetchData(from: endpoint) { [weak self] (response: MovieDetailModel) in
            guard let self = self else { return }
            self.movieDetails = response
        }

    }
    
    func fetchMovieCredits(id: Int){
        let endpoint = TMDBEndpoint.movieCredits(id: id)
        
        super.fetchData(from: endpoint) { [weak self] (response: MovieCreditsModel) in
            guard let self = self else { return }
            self.movieCredits = response
        }
    }
    
    func fetchData(id: Int){
        fetchMovieCredits(id: id)
        fetchMovieDetails(id: id)
    }
}
