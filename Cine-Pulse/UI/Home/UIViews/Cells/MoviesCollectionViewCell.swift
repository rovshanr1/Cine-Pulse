//
//  MovieCollectionViewCell.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 09.10.25.
//

import UIKit
import Kingfisher

class MoviesCollectionViewCell: UICollectionViewCell{

    private var movieImage: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
       
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = nil
    }
    override func layoutSubviews() {
        setupStyle()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle(){
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        contentView.clipsToBounds = true
    }
    
    private func setupViews(){
        contentView.addSubview(movieImage)
        
        NSLayoutConstraint.activate([
            movieImage.topAnchor.constraint(equalTo: self.topAnchor),
            movieImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            movieImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            movieImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func configureMoviesCollection(with movieList: MovieListModel.Movie){
        movieImage.kf.setImage(with: movieList.posterURL)
    }
} 
