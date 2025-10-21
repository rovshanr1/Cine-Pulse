//
//  MovieDetailsVC.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 09.10.25.
//

import UIKit
import Combine

class MovieDetailsVC: UIViewController, DetailUIViewDelegate {
    
    //Movie Model
    var movieList: MovieListModel.Movie?
    
    //Content View
    private let contentView = DetailUIView()
    
    //View Model
    private let vm = DetailViewModel()
    
    private var cancellabels = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        navigationItem.title = ""
        
        setupUI()
        bindViewModel()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationStyle()
    }
    
    private func setupNavigationStyle() {
        let style = NavigationBarStyle.movieDetailStyle
        navigationController?.navigationBar.standardAppearance = style
        navigationController?.navigationBar.scrollEdgeAppearance = style
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
        guard let movieId = movieList?.id else {
            
            //TODO: - Add Not Found movie error handling
            return
        }
        
        vm.fetchData(id: movieId)
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
            
        vm.$error
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {  error in
                if let error = error{
                    //TODO: - add error handling
                    print(error)
                }
            })
            .store(in: &cancellabels)
    }
    
    func didScroll(withY offset: CGFloat) {
        let headerHeight = AspectRatio.sixteenByNine.height(for: view.frame.width)
        let threshold = headerHeight - 64
        let alpha = min(max(offset / threshold, 0), 1)
        let showNavTitle = alpha > 0.8

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label.withAlphaComponent(alpha)]
        appearance.backgroundColor = showNavTitle ? .navigationBarBackground : .clear
        
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.title = showNavTitle ? movieList?.title : nil
        contentView.setPrimaryTitle(hidden: showNavTitle)
    }
}
