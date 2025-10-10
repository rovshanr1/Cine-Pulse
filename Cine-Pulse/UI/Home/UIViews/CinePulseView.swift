//
//  MovieListView.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 06.10.25.
//

import UIKit

class MovieListView: UIView {
    
    //identifier
    let reusableCell: String = "PopularMovieCell"
    
    //Movies
    private var movies: [MovieListModel.Movie] = []
    
    
    let popularMovieNavigationButton: PopularMovieButton = {
        let button = PopularMovieButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let popularMovieCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI(){
        addSubview(popularMovieNavigationButton)
        addSubview(popularMovieCollection)
        
        popularMovieCollection.translatesAutoresizingMaskIntoConstraints = false
        popularMovieCollection.delegate = self
        popularMovieCollection.dataSource = self
        popularMovieCollection.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: reusableCell)
        
        NSLayoutConstraint.activate([
            popularMovieNavigationButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            popularMovieNavigationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            popularMovieNavigationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            popularMovieCollection.topAnchor.constraint(equalTo: popularMovieNavigationButton.bottomAnchor, constant: 12),
            popularMovieCollection.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            popularMovieCollection.heightAnchor.constraint(equalToConstant: 225)
        ])
    }
    
    func configure(with movies: [MovieListModel.Movie]){
        self.movies = movies
        DispatchQueue.main.async {
            self.popularMovieCollection.reloadData()
        }
    }
    
}


extension MovieListView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCell, for: indexPath) as! MovieCollectionViewCell
    
        let movieItem = movies[indexPath.row]
        cell.configure(with: movieItem)
        
        return cell
    }
    
    
    
}

extension MovieListView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 225)
    }
}
     
