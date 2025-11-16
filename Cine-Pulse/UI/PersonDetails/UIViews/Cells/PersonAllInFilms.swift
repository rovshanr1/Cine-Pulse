//
//  PersonAllInFilms.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 11.11.25.
//

import UIKit

class PersonAllInFilms: UITableViewCell {
    
    static let reuseID: String = "PersonAllInFilms"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
       
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
    }
    
    public func configurePersonAllInFilms(with text: String) {
        label.text = text
    }
}

