//
//  CombinedCreditsCell.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 10.11.25.
//

import UIKit
import Kingfisher

protocol CombinedCreditsCellDelegate: AnyObject {
    func didSelectedCredit(at index: Int)
}

class CombinedCreditsCell: UITableViewCell {
    
    static let reuseID: String = "CombinedCreditsCell"

    weak var delegate: CombinedCreditsCellDelegate?
    
    private var items: [Any] = []
    
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 150)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cv.backgroundColor = .clear
        cv.register(MoviePosterCell.self, forCellWithReuseIdentifier: MoviePosterCell.reuseIdentifier)
        cv.isScrollEnabled = false
        return cv
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
        
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
     
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo:  contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 310)
        ])
    }
    public func configureCombinedCreditsCell(with data: [Any]) {
        self.items = data
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

//MARK: - UICollectionView Delegate & DataSource
extension CombinedCreditsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let maxItemsPerRow = 6
        
        return min(items.count, maxItemsPerRow)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.reuseIdentifier, for: indexPath) as? MoviePosterCell else {
            fatalError("Could not dequeue a new cell.")}
        
        let item = items[indexPath.row]
        
        if let caseCredit = item as? CombinedCreditsModel.Cast{
            cell.configureCombinedCast(with: caseCredit)
        }else if let crewCredit = item as? CombinedCreditsModel.Crew {
            cell.configureCombinedCrew(with: crewCredit)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectedCredit(at: indexPath.row)
    }
}
