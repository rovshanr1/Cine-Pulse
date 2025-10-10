//
//  MovieListViewModel.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 09.10.25.
//

import Foundation
import Combine

class MovieListViewModel: ObservableObject {
    @Published private(set) var movieList: [MovieListModel.Movie] = []
    @Published private(set) var error: String?
    @Published private(set) var isLoading: Bool = false
 
    private let networking: Networking
    private var cancellables = Set<AnyCancellable>()
    
    init(networking: Networking = BaseNetworking()){
        self.networking = networking
    }
    
    func fetchMovies(query: String? = nil, page: Int = 1) {
        isLoading = true
        error = nil
        
        networking.fetchData(TMDBEndpoint.movieList(query: query, page: page))
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] completion in
                guard let self = self else { return }
                isLoading = false
             
                if case .failure(let error) = completion {
                    self.error = error.localizedDescription
                }
                
            } receiveValue: { [weak self] (response: MovieListModel) in
                guard let self = self else { return }
                
                self.movieList = response.results
            }
            .store(in: &cancellables)
    }
}
