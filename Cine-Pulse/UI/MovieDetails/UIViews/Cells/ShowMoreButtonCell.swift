//
//  ShowMoreButtonCell.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 05.11.25.
//

import UIKit
protocol ShowMoreButtonDelegate: AnyObject {
    func didTapMoreButton()
}

class ShowMoreButtonCell: UITableViewCell {

    
    weak var delegate: ShowMoreButtonDelegate?
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show More", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        moreButton.addTarget(self, action: #selector(toggleContentExpansion), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            moreButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            moreButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            moreButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    public func configureMoreButton(title: String){
        moreButton.setTitle(title, for: .normal)
    }
    
    @objc private func toggleContentExpansion(){
        delegate?.didTapMoreButton()
    }

}
