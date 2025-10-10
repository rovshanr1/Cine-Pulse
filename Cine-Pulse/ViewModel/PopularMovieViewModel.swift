//
//  PopularMovieViewModel.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 09.10.25.
//

import Foundation
import Combine

class PopularMovieViewModel: ObservableObject{
    @Published private(set) var movies: [MovieListModel.Movie] = []
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoading: Bool = false
    
    private let networking: Networking
    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    init(networking: Networking = BaseNetworking()) {
        self.networking = networking
    }
    
    func fetchInitialMovies() {
        movies.removeAll()
        currentPage = 1
        totalPages = 1
        fetchNextPage()
    }
    
    func fetchNextPage() {
        guard !isLoading, currentPage <= totalPages else { return }
        
        isLoading = true
        errorMessage = nil
        
        networking.fetchData(TMDBEndpoint.movieList(query: nil, page: currentPage))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
            
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] (response: MovieListModel) in
                guard let self = self else { return }
                self.movies.append(contentsOf: response.results)
                currentPage += 1
                self.totalPages = response.totalPages
            }
            .store(in: &cancellables)
    }
}
