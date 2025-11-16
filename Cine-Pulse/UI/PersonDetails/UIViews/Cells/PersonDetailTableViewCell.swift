//
//  PersonDetailTableViewCell.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 08.11.25.
//

import UIKit
protocol PersonDetailTableViewCellDelegate: AnyObject {
    func didtapPersonImage(_ image: UIImage?)
}
class PersonDetailTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "PersonDetailTableViewCell"
    
    var onTogleExpand: (() -> Void)?
    
    weak var delegate: PersonDetailTableViewCellDelegate?
    
    private let personImageView: UIImageView = {
      let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private let personInformationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [personImageView, personInformationLabel])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .top
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupInformationTap()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        configureImageView()
    }
    
    private func setupUI(){
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            personImageView.widthAnchor.constraint(equalToConstant: 120),
            personImageView.heightAnchor.constraint(equalTo: personImageView.widthAnchor, multiplier: 1.5)
        ])
        
     
    }
    
    private func configureImageView(){
        personImageView.layer.cornerRadius = 8
        personImageView.layer.borderWidth = 0.5
        personImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
    }
    
    private func setupInformationTap(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapInformationLabel))
        personInformationLabel.addGestureRecognizer(tapGesture)
        personInformationLabel.isUserInteractionEnabled = true
    }
    
    @objc private func didTapInformationLabel(){
        onTogleExpand?()
    }
    
    public func configurePersonCell(with person: PersonModel, isExpand: Bool){
        personImageView.kf.setImage(with: person.personProfilePath)
        personInformationLabel.text = person.biography
        
        personInformationLabel.numberOfLines = isExpand ? 0 : 10
    }
}

//MARK: - Person Image tap gesture methods
extension PersonDetailTableViewCell {
    private func setupGesture(){
        if let gesture = personImageView.gestureRecognizers{
            for g in gesture{
                personImageView.removeGestureRecognizer(g)
            }
        }
        let top = UITapGestureRecognizer(target: self, action: #selector(didTapPerson))
        personImageView.addGestureRecognizer(top)
    }
    
    @objc private func didTapPerson(){
        delegate?.didtapPersonImage(personImageView.image)
    }
    
}


