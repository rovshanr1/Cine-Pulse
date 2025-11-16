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
    @Published var movieVideos: MovieVideoModel?
    @Published var movieRatings: [Int]?
    @Published var activeTab: DetailTab = .cast

    
    func fetchMovieDetails(id: Int){
        let endpoint = TMDBEndpoint.movieDetails(id: id)
        
        super.fetchData(from: endpoint) { [weak self] (response: MovieDetailModel) in
            guard let self = self else { return }
            
            self.movieDetails = response
            
            if let imdbID = response.imdbId, !imdbID.isEmpty{
                self.fetchMovieRatings(imdbID: imdbID)
            }else{
                self.movieRatings = Array(repeating: 0, count: 10)
            }
        }

    }
    
    private func fetchMovieCredits(id: Int){
        let endpoint = TMDBEndpoint.movieCredits(id: id)
        
        super.fetchData(from: endpoint) { [weak self] (response: MovieCreditsModel) in
            guard let self = self else { return }
            self.movieCredits = response
        }
    }
    
    
    private func fetchMovieVideo(id: Int){
        let endpoint = TMDBEndpoint.movieVideos(id: id)
        
        super.fetchData(from: endpoint) { [weak self] (response: MovieVideoModel)in
            guard let self = self else { return }
            self.movieVideos = response
        }
    }
    
    private func fetchMovieRatings(imdbID: String) {
        let endpoint = TraktEndpoint.movieRating(imdbID: imdbID)
        
        super.fetchData(from: endpoint) { [weak self] (response: MovieRatingsModel) in
            guard let self = self else{ return }
    
            self.movieRatings = response.getRatingDistributionArray()
        }
    }
    
    func setActiveTab(to tab: DetailTab) {
        self.activeTab = tab
    }
    
    func fetchData(id: Int){
        fetchMovieCredits(id: id)
        fetchMovieDetails(id: id)
        fetchMovieVideo(id: id)
    }
}
