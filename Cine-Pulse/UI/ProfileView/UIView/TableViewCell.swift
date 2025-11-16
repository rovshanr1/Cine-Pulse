//
//  TableViewCell.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 16.11.25.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String = "TableViewCell"

    var watchListLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    var listsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    var diaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    var saveLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
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
        
        contentView.addSubview(watchListLabel)
        contentView.addSubview(listsLabel)
        contentView.addSubview(diaryLabel)
        contentView.addSubview(saveLabel)
        
        watchListLabel.translatesAutoresizingMaskIntoConstraints = false
        listsLabel.translatesAutoresizingMaskIntoConstraints = false
        diaryLabel.translatesAutoresizingMaskIntoConstraints = false
        saveLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            watchListLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            watchListLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            watchListLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            watchListLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            listsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            listsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            listsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            listsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            diaryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            diaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            diaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            diaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            saveLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            saveLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            saveLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            saveLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
}
