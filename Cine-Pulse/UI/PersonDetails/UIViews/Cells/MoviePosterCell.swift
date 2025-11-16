//
//  MoviePosterCell.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 10.11.25.
//

import UIKit

protocol CombinedCreditsViewDelegate: AnyObject {
    func didSelected(at index: Int )
}

class MoviePosterCell: UICollectionViewCell {
    
    //identifier
    static let reuseIdentifier: String = "MoviePosterCell"
 
    private let combinedCreditsPosterImage: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        configureImageView()
    }
    
    private func setupUI(){
        backgroundColor = .clear
        
        contentView.addSubview(combinedCreditsPosterImage)
        combinedCreditsPosterImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            combinedCreditsPosterImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            combinedCreditsPosterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            combinedCreditsPosterImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            combinedCreditsPosterImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func configureImageView(){
        combinedCreditsPosterImage.layer.cornerRadius = 8
        combinedCreditsPosterImage.layer.borderWidth = 0.5
        combinedCreditsPosterImage.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
    }
    
    
    public func configureCombinedCast(with combinedCredits: CombinedCreditsModel.Cast) {
        combinedCreditsPosterImage.kf.setImage(with: combinedCredits.combinedCreditsCastPoster)
    }
    
    public func configureCombinedCrew(with combinedCredits: CombinedCreditsModel.Crew) {
        combinedCreditsPosterImage.kf.setImage(with: combinedCredits.combinedCreditsCrewPoster)
    }
    
}
