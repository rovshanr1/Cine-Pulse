//
//  MovieListView.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 06.10.25.
//

import UIKit

class MovieListView: UIView {
    
    //identifier
    private let reusableCell: String = "PopularMovieCell"
    
    //Movies
    private var movies: [MovieListModel.Movie] = []
    
    
    let popularMovieNavigationButton: PopularMovieButton = {
        let button = PopularMovieButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let popularThisWeekMovieCollection: UICollectionView = {
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
        addSubview(popularThisWeekMovieCollection)
        
        popularThisWeekMovieCollection.translatesAutoresizingMaskIntoConstraints = false
        popularThisWeekMovieCollection.delegate = self
        popularThisWeekMovieCollection.dataSource = self
        popularThisWeekMovieCollection.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: reusableCell)
        
        NSLayoutConstraint.activate([
            popularMovieNavigationButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            popularMovieNavigationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            popularMovieNavigationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            popularThisWeekMovieCollection.topAnchor.constraint(equalTo: popularMovieNavigationButton.bottomAnchor, constant: 12),
            popularThisWeekMovieCollection.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            popularThisWeekMovieCollection.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            popularThisWeekMovieCollection.heightAnchor.constraint(equalToConstant: 225)
        ])
    }
    
    func configurePopularThisWeekMovies(with movies: [MovieListModel.Movie]){
        self.movies = movies
        DispatchQueue.main.async {
            self.popularThisWeekMovieCollection.reloadData()
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
        cell.configureMoviesCollection(with: movieItem)
        
        return cell
    }
    
    
    
}

extension MovieListView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 225)
    }
}
     
