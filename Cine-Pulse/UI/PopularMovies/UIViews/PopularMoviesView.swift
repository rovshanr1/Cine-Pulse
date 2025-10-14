//
//  PopularMoviesView.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 12.10.25.
//

import UIKit

class PopularMoviesView: UIView {
    
    //identifier
    private let reuseIdentifier: String = "PopularMoviesCell"
    
    //Movies
    private var movies: [MovieListModel.Movie] = []
    
    //callback closure
    var onReachedEndOfList: (() -> Void)?
    
    //refresh controller
    private let refreshController = UIRefreshControl()
    var onPullToRefresh: (() -> Void)?
    
    private let vm = PopularMovieViewModel()
    
    let popularMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.scrollsToTop = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        addSubview(popularMoviesCollectionView)
        popularMoviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        popularMoviesCollectionView.delegate = self
        popularMoviesCollectionView.dataSource = self
        popularMoviesCollectionView.register(PopularMoviesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        popularMoviesCollectionView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        popularMoviesCollectionView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12)
        
        NSLayoutConstraint.activate([
            popularMoviesCollectionView.topAnchor.constraint(equalTo: topAnchor),
            popularMoviesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            popularMoviesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            popularMoviesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
    
    func configurePopularMovies(with movies: [MovieListModel.Movie]) {
        self.movies = movies
        DispatchQueue.main.async {
            self.popularMoviesCollectionView.reloadData()
        }
    }
    
    @objc private func didPullToRefresh(){
        onPullToRefresh?()
    }
}


extension PopularMoviesView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PopularMoviesCollectionViewCell
        
        let popularMovieItem = movies[indexPath.row]
        cell.configurePopularMoviesCollection(with: popularMovieItem)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 5{
            onReachedEndOfList?()
            refreshController.endRefreshing()
        }
    }
}

extension PopularMoviesView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
}
