//
//  AllMoviesCollectionViewCell.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 12.10.25.
//

import UIKit
import Kingfisher

class AllMoviesCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = "AllMoviesCell"
    
    private var allMovieImageView: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupStyle()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        allMovieImageView.kf.cancelDownloadTask()
        allMovieImageView.image = nil
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
        contentView.addSubview(allMovieImageView)
        
        NSLayoutConstraint.activate([
            allMovieImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            allMovieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            allMovieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            allMovieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureAllMoviesCollection(with movieList: MovieListModel.Movie){
        allMovieImageView.kf.setImage(with: movieList.posterURL)
    }
}
