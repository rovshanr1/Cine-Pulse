//
//  MovieListView.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 06.10.25.
//

import UIKit

class MovieListView: UIView {
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
        
        
        NSLayoutConstraint.activate([
            popularMovieNavigationButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            popularMovieNavigationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            popularMovieNavigationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
    
}


