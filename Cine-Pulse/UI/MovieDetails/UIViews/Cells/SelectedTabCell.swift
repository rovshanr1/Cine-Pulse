//
//  SelectedTabCell..swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 02.11.25.
//

import UIKit

protocol SelectedTabCellDelegate: AnyObject {
    func didSelectTab(_ movie: DetailTab)
}

class SelectedTabCell: UITableViewCell {

    weak var delegate: SelectedTabCellDelegate?
    
    private var tabs: [DetailTab] = [.cast, .crew, .genre]
    private var activeTab: DetailTab = .cast
    
    private var indicatorLeadingConstraint: NSLayoutConstraint?
    private var indicatorWidthConstraint: NSLayoutConstraint?
    
    //MARK: - UI Components
   
    private lazy var tabStackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 16
        return stack
    }()
    
   
    private func createButton(for tab: DetailTab) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(tab.tableLabel, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.tintColor = .secondaryLabel
        button.tag = tab.hashValue
        button.addTarget(self, action: #selector(tabTapped), for: .touchUpInside)
        return button
    }
    
    private let selectionIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(tabStackView)
        contentView.addSubview(selectionIndicator)
        
        indicatorLeadingConstraint = selectionIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        indicatorWidthConstraint = selectionIndicator.widthAnchor.constraint(equalToConstant: 0)
        
        tabs.forEach { tab in
            let button = createButton(for: tab)
            tabStackView.addArrangedSubview(button)
        }
        tabStackView.translatesAutoresizingMaskIntoConstraints = false
        selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tabStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            tabStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            tabStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            tabStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            
            selectionIndicator.bottomAnchor.constraint(equalTo: tabStackView.bottomAnchor, constant: 2),
            selectionIndicator.heightAnchor.constraint(equalToConstant: 2),
            
            indicatorLeadingConstraint!,
            indicatorWidthConstraint!
        ])
        
        updateSelectionIndicator(animated: false)
        updateButtonSyles()
    }
    
    @objc private func tabTapped(_ sender: UIButton) {
        if let newTab = tabs.first(where: {$0.hashValue == sender.tag}), newTab != activeTab {
            activeTab = newTab
            delegate?.didSelectTab(newTab)
            updateSelectionIndicator(animated: true)
        }
    }
    
    //MARK: - Private Helpers
    private func updateSelectionIndicator(animated: Bool){
        guard let activeButton = tabStackView.arrangedSubviews
            .compactMap({$0 as? UIButton})
            .first(where: {$0.tag == activeTab.hashValue})else { return }
        
        let animations = {
            let buttonFrame = activeButton.convert(activeButton.bounds, to: self.contentView)
            
            self.indicatorLeadingConstraint?.constant = buttonFrame.origin.x
            self.indicatorWidthConstraint?.constant = buttonFrame.width
            
            self.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: animations)
        } else {
            animations()
        }
    }
    
    private func updateButtonSyles() {
        tabStackView.arrangedSubviews.compactMap({$0 as? UIButton}).forEach {   button in
            let isActive = button.tag == activeTab.hashValue
            button.tintColor = isActive ? .label : .secondaryLabel
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: isActive ? .bold : .semibold)
        }
    }
    
    //MARK: - Public methods
    public func configureSelectedTab(withc activeTab: DetailTab){
        self.activeTab = activeTab
        DispatchQueue.main.async {
            self.updateSelectionIndicator(animated: false)
            self.updateButtonSyles()
        }
    }
   
}
