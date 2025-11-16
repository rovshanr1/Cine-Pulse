//
//  SelectableInfoView.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 03.11.25.
//

import UIKit
import Kingfisher

class SelectableInfoView: UIView {
    //MARK: - UI Elements
    private let personDetailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        return imageView
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let secondaryDetailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.6)
        label.numberOfLines = 1
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
    
    //MARK: - Stack Views
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [detailLabel, secondaryDetailLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        detailLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.addArrangedSubview(personDetailImageView)
        stackView.addArrangedSubview(labelStackView)
        stackView.addArrangedSubview(spacer)
        stackView.addArrangedSubview(rightArrowImage)
        
        
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stackView.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        
        personDetailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            personDetailImageView.widthAnchor.constraint(equalToConstant: 50),
            personDetailImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    public func crewConfigure(_ with: MovieCreditsModel.Crew) {
        personDetailImageView.kf.setImage(with: with.crewProfilePath)
        detailLabel.text = with.name
        secondaryDetailLabel.text = with.job
        
    }
    
    public func castConfigure(_ with: MovieCreditsModel.Cast) {
        personDetailImageView.kf.setImage(with: with.castProfilePath)
        detailLabel.text = with.character
        secondaryDetailLabel.text = with.originalName
    }
}
