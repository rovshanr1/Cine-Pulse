//
//  ProfileUIView.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 15.11.25.
//

import UIKit

class ProfileUIView: UIView{
    private var tableView: UITableView = {
        var tableView = UITableView()
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.reuseIdentifier)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        
        setupUI()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension ProfileUIView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.reuseIdentifier, for: indexPath) as? ProfileTableViewCell else {
                fatalError("Can not dequeue cell")
            }
            
            cell.profileImageView.image = UIImage(named: "ProfileImage")
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else {
                fatalError("Can not dequeue cell")
            }
            cell.watchListLabel.text = "Watchlist"
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else {
                fatalError("Can not dequeue cell")
            }
            cell.listsLabel.text = "Lists"
            
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else {
            fatalError("Can not dequeue cell")
        }
            cell.saveLabel.text = "Saved for later"
            
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else {
                fatalError("Can not dequeue cell")
            }
            
            cell.diaryLabel.text = "Diary"
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}
