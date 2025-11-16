//
//  GenresCell.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 09.11.25.
//

import UIKit

class GenresCell: UITableViewCell {
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(genreLabel)
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            genreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    public func configureGenreLabel(_ with: MovieDetailModel.Genre){
        genreLabel.text = with.name
    }

}
