//
//  MovieListView.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 06.10.25.
//

import UIKit

//MARK: - elected cell delegate
protocol MovieListViewDelegate: AnyObject {
    func didSelectMovie(at index: Int)
}

class MovieListView: UIView {

    //identifier
    private let reusableCell: String = "PopularMovieCell"
    
    //ViewModel
    private var vm = HomeViewModel()
    
    //Delegate
    weak var delegate: MovieListViewDelegate?
    
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
        
        popularThisWeekMovieCollection.contentInset.left = 12
        
        NSLayoutConstraint.activate([
            popularMovieNavigationButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            popularMovieNavigationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            popularMovieNavigationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            popularThisWeekMovieCollection.topAnchor.constraint(equalTo: popularMovieNavigationButton.bottomAnchor, constant: 12),
            popularThisWeekMovieCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
            popularThisWeekMovieCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            popularThisWeekMovieCollection.heightAnchor.constraint(equalToConstant: 225)
        ])
    }
    
    func configurePopularThisWeekMovies(with movies: [MovieListModel.Movie]){
        self.vm.movieList = movies
        DispatchQueue.main.async {
            self.popularThisWeekMovieCollection.reloadData()
        }
    }
    
}

//MARK: - UI Collection View Data Source Extension
extension MovieListView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCell, for: indexPath) as! MovieCollectionViewCell
    
        let movieItem = vm.movieList[indexPath.row]
        cell.configureMoviesCollection(with: movieItem)
        
        return cell
    }
}

//MARK: - UI Collection View Delegate Flow Layout Extension
extension MovieListView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 225)
    }
}

//MARK: - UI Collection View Delegate Extension
extension MovieListView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectMovie(at: indexPath.row)
    }
}
     

