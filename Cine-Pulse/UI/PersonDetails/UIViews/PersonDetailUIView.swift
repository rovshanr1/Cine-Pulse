//
//  PersonDetailUIView.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 08.11.25.
//

import UIKit


protocol PersonDiteilUiViewDelegate: AnyObject{
    func didSelectedMovieCredit(movieID: Int)
}

class PersonDetailUIView: UIView {
    
    weak var delegate: PersonDiteilUiViewDelegate?
    
    private enum PersonDetailSection: CaseIterable {
        case information
        case films
        case combinedCredits
    }
    //Views
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PersonDetailTableViewCell.self, forCellReuseIdentifier: PersonDetailTableViewCell.reuseIdentifier)
        tableView.register(PersonAllInFilms.self, forCellReuseIdentifier: PersonAllInFilms.reuseID)
        tableView.register(CombinedCreditsCell.self, forCellReuseIdentifier:  CombinedCreditsCell.reuseID)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    //Models
    private var personModel: PersonModel?
    private var combinedCredits: CombinedCreditsModel?
    
    //control propertys
    private var isInformationLabelExpanded: Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    public func configurePersonDetails(with person: PersonModel) {
        self.personModel = person
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    public func configureCombinedCredits(with combinedCredits: CombinedCreditsModel) {
        self.combinedCredits = combinedCredits
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


extension PersonDetailUIView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = PersonDetailSection.allCases[indexPath.row]
        
        switch section {
        case .information:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonDetailTableViewCell.reuseIdentifier, for: indexPath) as? PersonDetailTableViewCell else {
                fatalError("Could not dequeue a new cell.")
            }
            
            guard let person = self.personModel else { return cell }
            
            cell.configurePersonCell(with: person, isExpand: self.isInformationLabelExpanded)
            
            cell.onTogleExpand = { [weak self, weak cell] in
                guard let self, let cell = cell else { return }
                isInformationLabelExpanded.toggle()
                
                
                if let person = self.personModel {
                    cell.configurePersonCell(with: person, isExpand: self.isInformationLabelExpanded)
                }
                
                UIView.performWithoutAnimation {
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
             
            }
            cell.delegate = self
            
            return cell
        case .films:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonAllInFilms.reuseID, for: indexPath) as? PersonAllInFilms else{
                fatalError()
            }
            
            if let castList = self.combinedCredits?.cast {
                cell.configurePersonAllInFilms(with: "Actor in \(castList.count) films")
            }else if let crewList = self.combinedCredits?.crew {
                cell.configurePersonAllInFilms(with: "Director of \(crewList.count) films")
            }
            
            return cell
            
        case .combinedCredits:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CombinedCreditsCell.reuseID, for: indexPath) as? CombinedCreditsCell else{
                fatalError("Could not dequeue a new cell.")
            }
            if let castList = self.combinedCredits?.cast {
                cell.configureCombinedCreditsCell(with: castList)
            }else if let crewList = self.combinedCredits?.crew {
                cell.configureCombinedCreditsCell(with: crewList)
            }
            
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


extension PersonDetailUIView: PersonDetailTableViewCellDelegate {
    func didtapPersonImage(_ image: UIImage?) {
        guard let  image else { return }
        posterImageTapped(image)
    }
    
}

extension PersonDetailUIView: CombinedCreditsCellDelegate {
    func didSelectedCredit(at index: Int) {
        var selectedMovieID: Int?
        
        if let castList = self.combinedCredits?.cast, castList.indices.contains(index) {
            selectedMovieID = castList[index].id
        }else if let crewList = self.combinedCredits?.crew, crewList.indices.contains(index) {
            selectedMovieID = crewList[index].id
        }
        
        if let id = selectedMovieID{
            delegate?.didSelectedMovieCredit(movieID: id)
        }
    }
}
