//
//  MovieDetailsVC.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 09.10.25.
//

import UIKit
import Combine
import SafariServices

class MovieDetailsVC: UIViewController {
        
    private var movieID: Int
    
    //Content View
    private let contentView = DetailUIView()
    
    //View Model
    private let vm = DetailViewModel()
    
    private var cancellabels = Set<AnyCancellable>()
    
    init(movieID: Int) {
        self.movieID = movieID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        navigationItem.title = ""
        
        setupUI()
        bindViewModel()
        fetchData()
    }
    
    private func setupUI() {
        view.addSubview(contentView)
        
        contentView.delegate = self
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchData() {
        vm.fetchData(id: self.movieID)
    }
    
    private func bindViewModel() {
        vm.$movieDetails
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] movieDetails in
                guard let self = self, let details = movieDetails else { return }
                
                self.contentView.configureDetailView(with: details)
            })
            .store(in: &cancellabels)
        
        vm.$movieCredits
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] credits in
                guard let self = self, let credits = credits else {return}
                self.contentView.configureCredits(with: credits)
            })
            .store(in: &cancellabels)
        
        vm.$movieVideos
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] videos in
                guard let self = self, let videos = videos else { return }
                self.contentView.configureVideos(with: videos)
            })
            .store(in: &cancellabels)
        
        vm.$movieRatings
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] ratings in
                guard let self = self, let ratings = ratings else { return }
                
                self.contentView.configureRatings(with: ratings)
            })
            .store(in: &cancellabels)
        
        vm.$error
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {  error in
                if let error = error{
                    //TODO: - add error handling
                    print(error)
                }
            })
            .store(in: &cancellabels)
        
        vm.$activeTab
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tab in
                guard let self = self else { return }
                
                self.contentView.configureActiveTab(tab: tab)
                
            }
            .store(in: &cancellabels)
    }
    
   
}

//MARK: - UIView Delegate

extension MovieDetailsVC: DetailUIViewDelegate{
    func didScroll(withY offset: CGFloat) {
        let headerHeight = AspectRatio.sixteenByNine.height(for: view.frame.width)
        let threshold = headerHeight - 64
        let alpha = min(max(offset / threshold, 0), 1)
        let showNavTitle = alpha > 0.8
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label.withAlphaComponent(alpha)]
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.title = showNavTitle ? vm.movieDetails?.title : nil
        contentView.setPrimaryTitle(hidden: showNavTitle)
    }
    
    func didTapWatchTrailer(withKey key: String) {
        guard let url = URL(string: "https://www.youtube.com/watch?v=\(key)") else {
            print("Invalid Youtube Url")
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
    
    func didTapPerson(withID pesonID: Int) {
        let personDetailVC = PersonDetailViewController(personID: pesonID)
        
        navigationController?.pushViewController(personDetailVC, animated: true)
    }
}
