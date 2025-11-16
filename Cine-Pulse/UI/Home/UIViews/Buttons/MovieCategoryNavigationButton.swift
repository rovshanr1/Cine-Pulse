//
//  PopularMovieButton.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 07.10.25.
//

import UIKit

final class MovieCategoryNavigationButton: UIButton {
    
    var category: MovieCategory?
    
    private let moviesCategoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "proximanova-regular", size: 24)
        label.textAlignment = .left
        return label
    }()
    
    private let rightArrowImage: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular, scale: .large)
        imageView.image = UIImage(systemName: "chevron.right", withConfiguration: config)
        imageView.tintColor = UIColor.white.withAlphaComponent(0.5)
        imageView.contentMode = .scaleAspectFit
       return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    override init(frame: CGRect) {
       super.init(frame: frame)
       setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI(){
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        moviesCategoryLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        stackView.addArrangedSubview(moviesCategoryLabel)
        stackView.addArrangedSubview(spacer)
        stackView.addArrangedSubview(rightArrowImage)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    public func setCategoryTitle(_ title: String){
        moviesCategoryLabel.text = title
    }
}
