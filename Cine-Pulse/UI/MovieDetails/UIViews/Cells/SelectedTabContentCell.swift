//
//  SelectedTabContentCell.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 03.11.25.
//

import UIKit



class SelectedTabContentCell: UITableViewCell {
    let contentDisplayView = SelectableInfoView()
    
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
        
        contentView.addSubview(contentDisplayView)
        contentDisplayView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentDisplayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentDisplayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentDisplayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentDisplayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

