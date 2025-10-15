//
//  PopularMoviesVC.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 09.10.25.
//

import UIKit
import Combine

class PopularMoviesVC: UIViewController, PopularMoviesViewDelegate {
   
    
    
    //Combine
    private var cancellabels = Set<AnyCancellable>()
    
    //View Models
    private var vm = PopularMovieViewModel()
    
    //Content View
    private let contentView = PopularMoviesView()
    private let detailView = MovieDetailsVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = UIColor(named: "Background")
        
        setupNavigationBar()
        setupUI()
        
        //VM binding
        bindViewModel()
        vm.fetchInitialMovies()
        
        contentView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
     
    }
    
    //MARK: - Navigation Bar
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Popular This Week"
        titleLabel.font = UIFont(name: "proximanovacond-boldit", size: 42)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        let style = NavigationBarStyle.popularMovieStyle
        navigationController?.navigationBar.standardAppearance = style
        navigationController?.navigationBar.scrollEdgeAppearance = style
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
        vm.$movieList
            .sink(receiveValue: { [weak self] movies in
                guard let self = self else { return }
                
                self.contentView.configurePopularMovies(with: movies)
            })
            .store(in: &cancellabels)
    }
    
    //MARK: - PopularMovieView Delegate
    func didSelectMovie(at index: Int) {
        guard let selectedMovie = vm.movie(at: index) else{
            print("Error: movie not found")
            return
        }
        
        print("get movie: \(selectedMovie.title)")
        
        navigationController?.pushViewController(detailView, animated: true)
    }
    
}
