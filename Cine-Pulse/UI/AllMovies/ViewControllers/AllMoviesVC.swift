//
//  AllMoviesVC.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 09.10.25.
//

import UIKit
import Combine

class AllMoviesVC: UIViewController, AllMoviesViewDelegate {
    
    //Combine
    private var cancellabels = Set<AnyCancellable>()
    
    //View Models
    private var vm: AllMoviesViewModel
    
    private let category: MovieCategory
    
    //Content View
    private let contentView = AllMoviesView()
    
    init(category: MovieCategory){
        self.category = category
        self.vm = AllMoviesViewModel(category: category)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .background
        navigationItem.title = category.displayTitle
        
        setupUI()
    
        bindViewModel()
        vm.fetchInitialMovies()
        
        contentView.delegate = self
    }
    
    //MARK: - Setup UI
    private func setupUI(){
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.onReachedEndOfList = { [weak self] in
            guard let self = self else { return }
            self.vm.fetchNextPage()
        }
        
        contentView.onPullToRefresh = { [weak self] in
            guard let self = self else { return }
            self.vm.fetchInitialMovies()
        }
        
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: - Binding View Model
    private func bindViewModel(){
        vm.$movie
            .sink(receiveValue: { [weak self] movies in
                guard let self = self else { return }
                
                self.contentView.configureAllMovies(with: movies)
            })
            .store(in: &cancellabels)
        
        vm.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                
                if !isLoading{
                    self.contentView.stopRefreshing()
                }
            }
            .store(in: &cancellabels)
    }
    
    //MARK: - PopularMovieView Delegate
    func didSelectMovie(at index: Int) {
        guard let selectedMovie = vm.movie(at: index) else{
            print("Error: movie not found")
            return
        }
        
        let movieDetailVC = MovieDetailsVC(movieID: selectedMovie.id)
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
    
}
