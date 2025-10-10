//
//  CinePulseViewController.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 03.10.25.
//

import UIKit
import Combine
class CinePulseViewController: UIViewController {
    
    //Combine
    private var cancellables = Set<AnyCancellable>()
    
    //ViewModels
    private var vm = MovieListViewModel()
    
    //Views
    private let contentView = MovieListView()
    private let vc = PopularMoviesVC()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        
        setupUI()
        navigationActions()
        
        bindViewModel()
        vm.fetchMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
       
    }
    
    //MARK: - Navigation Bar Style
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Cine Pulse"
        titleLabel.font = UIFont(name: "proximanovacond-boldit", size: 42)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        let style = NavigationBarStyle.cinePulseStyle
        navigationController?.navigationBar.standardAppearance = style
        navigationController?.navigationBar.scrollEdgeAppearance = style
    }
    
    //MARK: - Setup UI
    private func setupUI(){
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: - Binding View Model
    private func bindViewModel(){
        vm.$movieList
            .sink(receiveValue: { [weak self] movie in
            guard let self = self else { return }
                self.contentView.configure(with: movie)
        })
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
    private func navigationActions(){
        contentView.popularMovieNavigationButton.addTarget(self, action: #selector(navigationToPopularMovies), for: .touchUpInside)
    }
    
    //MARK: - Target objc func
    @objc private func navigationToPopularMovies() {
        navigationController?.pushViewController(vc, animated: true)
    }
}



