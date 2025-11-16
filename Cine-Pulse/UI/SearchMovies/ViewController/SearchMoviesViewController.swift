//
//  SearchMoviesViewController.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 31.10.25.
//

import UIKit
import Combine

class SearchMoviesViewController: UIViewController {
    //Search Controller
    let searchController = UISearchController(searchResultsController: nil)
    
    //Content View
    private var cv = AllMoviesView()
    
    //View Model
    private var vm = SearchViewModel()
    
    //Cancellabels
    private var cancellabel = Set<AnyCancellable>()
    
    //Loading Indicator
    private let loadingIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        navigationItem.title = "Search"
        
        setupSearchController()
        setupUI()
        bindVM()
        
        vm.input.fetchPopular.send()
    }
    
    //MARK: - Setup Serach Controller
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        view.addSubview(cv)
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        cv.onReachedEndOfList = { [weak self] in
            self?.vm.input.loadMore.send()
        }
        cv.onPullToRefresh = { [weak self] in
            guard let self else { return }
            if let query = self.searchController.searchBar.text, !query.isEmpty {
                self.vm.input.searchText.send(query)
            }else {
                self.vm.input.fetchPopular.send()
            }
        }
        
        cv.delegate = self
        
        NSLayoutConstraint.activate([
            cv.topAnchor.constraint(equalTo: view.topAnchor),
            cv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
    }
    
    //MARK: - ViewModel binding
    private func bindVM() {
        vm.output.movies
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] movies in
            guard let self else { return }
            self.cv.configureAllMovies(with: movies)
        })
        .store(in: &cancellabel)
            
    }
    
}

//MARK: - UISerachResultsUpdating
extension SearchMoviesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        vm.input.searchText.send(query)
    }
}

//MARK: - Delegates
extension SearchMoviesViewController: AllMoviesViewDelegate{
    func didSelectMovie(at index: Int) {
        guard index < vm.output.movies.value.count else { return }
        
        let selectedMovie = vm.output.movies.value[index]
        
        let movieDetailVC = MovieDetailsVC(movieID: selectedMovie.id)
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}
