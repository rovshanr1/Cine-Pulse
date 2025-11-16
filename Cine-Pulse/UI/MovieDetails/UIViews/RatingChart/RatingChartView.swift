//
//  RatingChartView.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 23.10.25.
//

import UIKit

class RatingChartView: UIView {
    
    private var ratingData: [Int] = []
    
    public var onBarTapped: ((_ rating: Double, _ count: Int) -> Void)?
    
    private var barFillConstraints: [NSLayoutConstraint] = []
    private var countLabels: [UILabel] = []
    private var selectedBarIndex: Int?
    
    public var highlightColor: UIColor = .systemGray
    public var defaultColor: UIColor = .systemGray.withAlphaComponent(0.3)
    public var trackColor: UIColor = .secondarySystemBackground
    public var labelColor: UIColor = .label
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillEqually
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
        addSubview(mainStackView)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    //MARK: - Public configure
    public func chartConfigure(with rating: [Int]) {
        guard rating.count == 10, let maxCount = rating.max(), maxCount > 0 else {
            mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            return
        }
        
        self.ratingData = rating
        
        //Remove previous views
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        barFillConstraints.removeAll()
        countLabels.removeAll()
        selectedBarIndex = nil
        
        for (index, count) in rating.enumerated() {
            _ = createRatingRow(index: index, count: count, maxCount: maxCount)
        }
        
        DispatchQueue.main.async {
            self.animateBars()
        }
    }
    
    //MARK: - View Creation
    private func createRatingRow(index: Int, count: Int, maxCount: Int) -> UIView {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.alignment = .center
        hStack.tag = index
        hStack.isUserInteractionEnabled = true
        
        let ratingValue = (Double(index) + 1.0) / 2.0
        
        let starStackView = createStarStackView(for: ratingValue)
        
        let barTrack = UIView()
        barTrack.backgroundColor = trackColor
        barTrack.layer.cornerRadius = 4
        barTrack.translatesAutoresizingMaskIntoConstraints = false
        
        let barFill = UIView()
        let isMax = (count == maxCount)
        barFill.backgroundColor = isMax ? highlightColor : defaultColor
        barFill.layer.cornerRadius = 4
        barFill.translatesAutoresizingMaskIntoConstraints = false
        
        barTrack.addSubview(barFill)

        let percentage = Double(count) / Double(maxCount)
        let targetWidthConstraint = barFill.widthAnchor.constraint(equalTo: barTrack.widthAnchor, multiplier: percentage)
        
        let zeroWidthConstraint = barFill.widthAnchor.constraint(equalToConstant: 0)
        zeroWidthConstraint.isActive = true
        
        barFillConstraints.append(targetWidthConstraint)
        
        NSLayoutConstraint.activate([
            starStackView.widthAnchor.constraint(equalToConstant: 55),
            barTrack.heightAnchor.constraint(equalToConstant: 16),
            
            barFill.leadingAnchor.constraint(equalTo: barTrack.leadingAnchor),
            barFill.topAnchor.constraint(equalTo: barTrack.topAnchor),
            barFill.bottomAnchor.constraint(equalTo: barTrack.bottomAnchor),
        ])
        
        let countLabel = UILabel()
        countLabel.text = formattedCount(count)
        countLabel.font = .systemFont(ofSize: 12, weight: .regular)
        countLabel.textColor = .secondaryLabel
        countLabel.alpha = 0.0
        countLabel.setContentHuggingPriority(.required, for: .horizontal)
        countLabels.append(countLabel)
        
        hStack.addArrangedSubview(starStackView)
        hStack.addArrangedSubview(barTrack)
        hStack.addArrangedSubview(countLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        hStack.addGestureRecognizer(tap)
        
        mainStackView.addArrangedSubview(hStack)
        return hStack
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer){
        guard let index = gesture.view?.tag else { return }
        
        let newIndex: Int? = (selectedBarIndex == index) ? nil: index
        self.selectedBarIndex = newIndex
        
        updateSelectionState()
        
        if let newIndex = newIndex {
            let ratingValue = (Double(newIndex) + 1.0) / 2.0
            onBarTapped?(ratingValue, ratingData[newIndex])
        }
    }
    
    
    private func updateSelectionState(){
        UIView.animate(withDuration: 0.2) {
            for (index, label) in self.countLabels.enumerated() {
                label.alpha = (self.selectedBarIndex == index) ? 1.0 : 0.0
            }
        }
    }
    
    private func animateBars() {
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut) {
            for (index, targetConstraint) in self.barFillConstraints.enumerated() {
                guard let hStack = self.mainStackView.arrangedSubviews[index] as? UIStackView else { continue }
                let barTrack = hStack.arrangedSubviews[1]
                guard let barFill = barTrack.subviews.first else { continue }
                
            
                barFill.constraints.first(where: { $0.firstAttribute == .width && $0.constant == 0})?.isActive = false
                
                targetConstraint.isActive = true
            }
            self.layoutIfNeeded()
        }
    }

    private func createStarStackView(for rating: Double) -> UIStackView{
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        let sybloConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .regular)
        
        for i in 1...5 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            
            let val = Double(i)
            let imageName: String
            let color: UIColor
            
            if rating >= val {
                imageName = "star.fill"
                color = .systemGreen
            }else if rating >= (val - 0.5){
                imageName = "star.leadinghalf.filled"
                color = .systemGreen
            }else{
                imageName = "star"
                color = .systemGray4
            }
            
            imageView.image = UIImage(systemName: imageName, withConfiguration: sybloConfig)
            imageView.tintColor = color
            stackView.addArrangedSubview(imageView)
        }
        
        return stackView
    }

    private func formattedCount(_ count: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        return formatter.string(from: NSNumber(value: count)) ?? "\(count)"
    }
}

