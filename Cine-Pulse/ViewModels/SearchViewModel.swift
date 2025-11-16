//
//  SearchViewModel.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 12.11.25.
//

import Foundation
import Combine

final class SearchViewModel: BaseViewModel {
    private var currentPage: Int = 1
    private var totalPages: Int? = nil
    private var lastQuery: String? = nil
    
    struct Input {
        let searchText = PassthroughSubject<String, Never>()
        let fetchPopular = PassthroughSubject<Void, Never>()
        let loadMore = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let movies = CurrentValueSubject<[MovieListModel.Movie], Never>([])
    }
    
    let input: Input
    let output: Output
    
    override init(networking: Networking = BaseNetworking()) {
        self.input = Input()
        self.output = Output()
        
        super.init(networking: networking)
        
        transform()
    }
    
    private func transform(){
        input.searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                guard let self else { return }
                self.lastQuery =  searchText.isEmpty ? nil : searchText
                self.currentPage = 1
                self.output.movies.send([])
                self.fetchMovies(query: self.lastQuery, page: self.currentPage)
            }
            .store(in: &cancellables)
        
        input.fetchPopular
            .sink { [weak self] _ in
                guard let self else { return }
                self.lastQuery = nil
                self.currentPage = 1
                self.output.movies.send([])
                self.fetchMovies(query: self.lastQuery, page: self.currentPage)
            }
            .store(in: &cancellables)
        
        input.loadMore
            .sink { [weak self] _ in
                guard let self else { return }
                self.loadNextPage()
            }
            .store(in: &cancellables)
        
    }
    
    private func fetchMovies(query: String?,  page: Int){
        guard !isLoading else { return }
        
        self.fetchData(from: TMDBEndpoint.movieList(query: query, page: page)) { [weak self] (response: MovieListModel) in
          guard let self else { return }
         
            self.totalPages = response.totalPages
            
            if page == 1 {
                self.output.movies.send(response.results)
            }else{
                var current = self.output.movies.value
                current.append(contentsOf: response.results)
                self.output.movies.send(current)
            }
        }
    }
    
    private func loadNextPage(){
        if let totalPages, currentPage >= totalPages { return }
        currentPage += 1
        fetchMovies(query: lastQuery, page: currentPage)
    }
}
