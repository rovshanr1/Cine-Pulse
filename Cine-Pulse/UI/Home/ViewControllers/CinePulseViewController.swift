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
    //Views
    private let contentView = MovieListView()
    private let vc = PopularMoviesVC()
    
    //Model
    private var movieListModel: MovieListModel?
    
    //identifier
    let reusablePopularMovieCell: String = "PopularMovieCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "Background")
        
        setupUI()
        navigationActions()
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
    
    //MARK: - Navigation
    private func navigationActions(){
        contentView.popularMovieNavigationButton.addTarget(self, action: #selector(navigationToPopularMovies), for: .touchUpInside)
    }
    
    //MARK: - Target objc func
    @objc private func navigationToPopularMovies() {
        navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - Collection View Data Source
//extension CinePulseViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//    
//    
//}


