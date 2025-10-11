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
    
    let popularMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.scrollsToTop = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        addSubview(popularMoviesCollectionView)
        popularMoviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        popularMoviesCollectionView.delegate = self
        popularMoviesCollectionView.dataSource = self
        popularMoviesCollectionView.register(PopularMoviesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        NSLayoutConstraint.activate([
            popularMoviesCollectionView.topAnchor.constraint(equalTo: topAnchor),
            popularMoviesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            popularMoviesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            popularMoviesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
            
        ])
    }
    
    func configurePopularMovies(with movies: [MovieListModel.Movie]) {
        self.movies = movies
        DispatchQueue.main.async {
            self.popularMoviesCollectionView.reloadData()
        }
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
}

extension PopularMoviesView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
}
