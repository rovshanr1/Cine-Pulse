//
//  PersonDetailViewController.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 06.11.25.
//

import UIKit
import Combine

class PersonDetailViewController: UIViewController {
    //Combine
    private var cancellables: Set<AnyCancellable> = []
    
    //View
    private let contentView = PersonDetailUIView()
    
    //Model
    private var vm = PersonDetailsViewModel()
    
    private let personID: Int
    
    init(personID: Int) {
        self.personID = personID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        setupUI()
        bindViewModel()
        fetchData()
    }
    
    
    private func setupUI() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.delegate = self
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchData() {
        vm.fetchPersonData(id: personID)
    }
    
    private func bindViewModel() {
        vm.$person
            .receive(on: DispatchQueue.main)
            .sink { [weak self] person in
                guard let self = self, let person = person else { return }
                self.navigationItem.title = person.name
                self.contentView.configurePersonDetails(with: person)
            }
            .store(in: &cancellables)
        
        vm.$combinedCredits
            .receive(on: DispatchQueue.main)
            .sink { [weak self] combinadCredits in
                guard let self = self, let combinedCredits = combinadCredits else { return }
                self.contentView.configureCombinedCredits(with: combinedCredits)
            }
            .store(in: &cancellables)
    }
    
}



extension PersonDetailViewController: PersonDiteilUiViewDelegate{
    func didSelectedMovieCredit(movieID: Int) {
        let movieDetailVC = MovieDetailsVC(movieID: movieID)
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}
