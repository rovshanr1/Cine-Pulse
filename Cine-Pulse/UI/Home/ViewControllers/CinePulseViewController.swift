//
//  CinePulseViewController.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 03.10.25.
//

import UIKit
import Combine
class CinePulseViewController: UIViewController, MovieListViewDelegate {
    
    //Combine
    private var cancellables = Set<AnyCancellable>()
    
    //ViewModels
    private var vm = HomeViewModel()
    
    //Views
    private let contentView = MovieListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        navigationItem.title = "Cine-Pulse" 
        
        setupUI()
        
        bindViewModel()
        fetchData()
        contentView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    //MARK: - Setup UI
    private func setupUI(){
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchData(){
        vm.fetchPopularMovies()
        vm.fetchTopRatedMovies()
        vm.fetchUpcomingMovies()
    }
    
    //MARK: - Binding View Model
    private func bindViewModel(){
        vm.$movie
            .sink(receiveValue: { [weak self] movie in
                guard let self = self else { return }
                self.contentView.configurePopularThisWeekMovies(with: movie)
            })
            .store(in: &cancellables)
        
        vm.$topRatedMovies
            .sink { [weak self] movies in
                guard let self = self else { return }
                self.contentView.configureTopRatedMovies(with: movies)
            }
            .store(in: &cancellables)
        vm.$upcomingMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                guard let self = self else { return }
                self.contentView.configureUpcomingMovies(with: movies)
            }
            .store(in: &cancellables)
        
        vm.$error
            .receive(on: DispatchQueue.main)
            .sink {[weak self] error in
                guard let self = self else { return }
                
                if let error = error {
                    guard self.presentedViewController == nil else { return }
                    
                    let alert = UIAlertController(title: "Oops, something went wrong", message: error, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Navigation
    
    func didTapSeeAllButton(for category: MovieCategory) {
        let allMoviesVC = AllMoviesVC(category: category)
        navigationController?.pushViewController(allMoviesVC, animated: true)
    }
    
    //MARK: - MovieListView Delegate
    func didSelectMovie(category: MovieCategory,at index: Int) {
        let selectedMovie: MovieListModel.Movie?
        
        switch category{
        case .popularMovie:
            guard index < vm.movie.count else { return }
            selectedMovie = vm.movie[index]
        case .topRated:
            guard index < vm.topRatedMovies.count else { return }
            selectedMovie = vm.topRatedMovies[index]
            
        case .upcoming:
            guard index < vm.upcomingMovies.count else { return }
            selectedMovie = vm.upcomingMovies[index]
        }
        
        guard let movie = selectedMovie else { return }
        
        let movieDetailVC = MovieDetailsVC(movieID: movie.id)
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}



