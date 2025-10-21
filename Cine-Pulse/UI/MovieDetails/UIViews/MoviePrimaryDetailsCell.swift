//
//  MoviePrimaryDetailsCell.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 21.10.25.
//

import UIKit
import Kingfisher

protocol MoviePrimaryDetailsDelegate: AnyObject{
    func didTapPosterImage(_ image: UIImage?)
}

class MoviePrimaryDetailsCell: UITableViewCell {
    
    weak var delegate: MoviePrimaryDetailsDelegate?
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let directorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    
    
    //Stack Views
    private lazy var releaseDateAndDirectorStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [releaseDateLabel, directorLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, releaseDateAndDirectorStackView])
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [infoStackView, posterImageView])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .top
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupStyle()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(mainStackView)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5)
            
        ])
    }
    
    private func setupStyle() {
        posterImageView.layer.cornerRadius = 10
        posterImageView.layer.borderWidth = 0.5
        posterImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
    }
    
    
    func setTitleLabel(hidden: Bool){
        let targetAlpha: CGFloat = hidden ? 0.0 : 1.0
        if self.titleLabel.alpha == targetAlpha {
            return
        }
        
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       animations: {self.titleLabel.alpha = targetAlpha},
                       completion: nil
        )
    }
    
   
}

//MARK: - Configuration methods
extension MoviePrimaryDetailsCell{
    func configureDirector(with credits: MovieCreditsModel){
        if let directorName = credits.director{
            directorLabel.text = "\(directorName)"
            directorLabel.isHidden = false
        }else{
            directorLabel.isHidden = true
        }
    }
    
    func configureDetailsCell(with movie: MovieDetailModel) {
        titleLabel.text = movie.title
        releaseDateLabel.text = "\(movie.extractYear) • Directed by"
        
        if let posterPath = movie.posterPathAsURL {
            posterImageView.kf.setImage(with: posterPath)
        }
    }
}

//MARK: - Poster Image tap gesture method
extension MoviePrimaryDetailsCell{
    private func setupGesture(){
        if let gesture = posterImageView.gestureRecognizers{
            for g in gesture {
                posterImageView.removeGestureRecognizer(g)
            }
        }
        let top = UITapGestureRecognizer(target: self, action: #selector(didTapPoster))
        posterImageView.addGestureRecognizer(top)
    }
    
    @objc private func didTapPoster(){
        delegate?.didTapPosterImage(posterImageView.image)
    }
}
