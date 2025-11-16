//
//  MovieCategoryRowCell.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 28.10.25.
//

import UIKit

protocol MovieCategoryRowCellDelegate: AnyObject{
    func categoryCellDidSelectedMovie(at index: Int, in cell: MovieCategoryRowCell)
    func cateforyButtonWasTapped( in cell: MovieCategoryRowCell)
}

class MovieCategoryRowCell: UITableViewCell {
    
    static let identifier = "MovieCategoryRowCell"
    private let reusableCell: String = "MovieCell"
    private var movies: [MovieListModel.Movie] = []
    
    weak var delegate: MovieCategoryRowCellDelegate?

    let movieNavigationButton = MovieCategoryNavigationButton()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.contentInset.left = 12
        collectionView.contentInset.right = 12
        collectionView.contentInset.bottom = 8
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        setupCollectionView()
        setupUI()
        
        movieNavigationButton.addTarget(self, action: #selector(navigationButtonTapped), for: .touchUpInside)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func navigationButtonTapped(){
        delegate?.cateforyButtonWasTapped(in: self)
    }
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: reusableCell)
    }
    
    private func setupUI(){
        contentView.addSubview(collectionView)
        contentView.addSubview(movieNavigationButton)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        movieNavigationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieNavigationButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieNavigationButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            movieNavigationButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            collectionView.topAnchor.constraint(equalTo: movieNavigationButton.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    public func configureRowCell(title: String, with movies: [MovieListModel.Movie], category: MovieCategory){
        self.movies = movies
        
        movieNavigationButton.setCategoryTitle(title)
        movieNavigationButton.category = category
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension MovieCategoryRowCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCell, for: indexPath) as! MoviesCollectionViewCell
        let movieItem = movies[indexPath.row]
        cell.configureMoviesCollection(with: movieItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 225)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.categoryCellDidSelectedMovie(at: indexPath.row, in: self)
    }
}
