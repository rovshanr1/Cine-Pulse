//
//  AllMoviesView.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 12.10.25.
//

import UIKit

protocol AllMoviesViewDelegate: AnyObject {
    func didSelectMovie(at index: Int)
}


class AllMoviesView: UIView {
    
    //Model
    private var movie: [MovieListModel.Movie] = []
    
    //Delegate
    weak var delegate: AllMoviesViewDelegate?
    
    //callback closure
    var onReachedEndOfList: (() -> Void)?
    
    //refresh controller
    private let refreshController = UIRefreshControl()
    var onPullToRefresh: (() -> Void)?
    
    
    let allMoviesCollectionView: UICollectionView = {
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
        addSubview(allMoviesCollectionView)
        allMoviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        allMoviesCollectionView.delegate = self
        allMoviesCollectionView.dataSource = self
        allMoviesCollectionView.register(AllMoviesCollectionViewCell.self, forCellWithReuseIdentifier: AllMoviesCollectionViewCell.reuseIdentifier)
        
        allMoviesCollectionView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        allMoviesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        NSLayoutConstraint.activate([
            allMoviesCollectionView.topAnchor.constraint(equalTo: topAnchor),
            allMoviesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            allMoviesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            allMoviesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
    
    func configureAllMovies(with movies: [MovieListModel.Movie]) {
        self.movie = movies
        DispatchQueue.main.async {
            self.allMoviesCollectionView.reloadData()
        }
    }
    
    @objc private func didPullToRefresh(){
        onPullToRefresh?()
    }
    
    func stopRefreshing(){
        DispatchQueue.main.async {
            self.refreshController.endRefreshing()
        }
    }
}

//MARK: - UI Collection View Data Source Extension
extension AllMoviesView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllMoviesCollectionViewCell.reuseIdentifier, for: indexPath) as! AllMoviesCollectionViewCell
        
        let popularMovieItem = movie[indexPath.row]
        cell.configureAllMoviesCollection(with: popularMovieItem)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movie.count - 5{
            onReachedEndOfList?()
        }
    }
}

//MARK: - UI Collection View Delegate Flow Layout Extension
extension AllMoviesView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
}

//MARK: - UI Collection View Delegate Extension
extension AllMoviesView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectMovie(at: indexPath.row)
    }
}
