//
//  PopularMoviesCollectionViewCell.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 12.10.25.
//

import UIKit
import Kingfisher

class PopularMoviesCollectionViewCell: UICollectionViewCell {
    
    private var popularMovieImageView: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupStyle()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        popularMovieImageView.kf.cancelDownloadTask()
        popularMovieImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle() {
    
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        contentView.clipsToBounds = true
    }
    
    private func setupViews(){
        contentView.addSubview(popularMovieImageView)
        
        NSLayoutConstraint.activate([
            popularMovieImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            popularMovieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            popularMovieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            popularMovieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configurePopularMoviesCollection(with movieList: MovieListModel.Movie){
        popularMovieImageView.kf.setImage(with: movieList.posterURL)
    }
}
