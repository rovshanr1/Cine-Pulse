//
//  PopularMoviesVC.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 09.10.25.
//

import UIKit
import Combine

class PopularMoviesVC: UIViewController {
    
    //Combine
    private var cancellabels = Set<AnyCancellable>()
    
    //View Models
    private var vm = PopularMovieViewModel()
    
    //Content View
    private let contentView = PopularMoviesView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = UIColor(named: "Background")
        
        setupNavigationBar()
        setupUI()
        
        //VM binding
        bindViewModel()
        vm.fetchNextPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
     
    }
    
    //MARK: - Navigation Bar
    private func setupNavigationBar() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        let style = NavigationBarStyle.popularMovieStyle
        navigationController?.navigationBar.standardAppearance = style
        navigationController?.navigationBar.scrollEdgeAppearance = style
    }
    
    //MARK: - Setup UI
    private func setupUI(){
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: - Binding View Model
    private func bindViewModel(){
        vm.$movies
            .sink(receiveValue: { [weak self] movies in
                guard let self = self else { return }
                
                self.contentView.configurePopularMovies(with: movies)
            })
            .store(in: &cancellabels)
    }
    
}
