//
//  MovieListView.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 06.10.25.
//

import UIKit

//MARK: - Selected cell delegate
protocol MovieListViewDelegate: AnyObject {
    func didSelectMovie(category: MovieCategory, at index: Int)
    func didTapSeeAllButton(for category: MovieCategory)
}

class MovieListView: UIView {
    //Models
    private var popularMovies: [MovieListModel.Movie] = []
    private var topRatedMovies: [MovieListModel.Movie] = []
    private var upcomingMovies: [MovieListModel.Movie] = []
    
    private var activeSections: [MovieCategory] {
        var sections: [MovieCategory] = []
        
        if !popularMovies.isEmpty { sections.append(.popularMovie) }
        if !topRatedMovies.isEmpty { sections.append(.topRated) }
        if !upcomingMovies.isEmpty { sections.append(.upcoming) }
        
        return sections
    }
    
    //Delegate
    weak var delegate: MovieListViewDelegate?
    

    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MovieCategoryRowCell.self, forCellReuseIdentifier: MovieCategoryRowCell.identifier)
        return tableView
    }()

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupUI(){
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configurePopularThisWeekMovies(with movies: [MovieListModel.Movie]){
        self.popularMovies = movies
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    func configureTopRatedMovies(with movies: [MovieListModel.Movie]){
        self.topRatedMovies = movies
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    func configureUpcomingMovies(with movies: [MovieListModel.Movie]){
        self.upcomingMovies = movies
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
}

//MARK: - UI Collection View Data Source Extension
extension MovieListView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCategoryRowCell.identifier, for: indexPath) as! MovieCategoryRowCell
        
        cell.delegate = self
        
        let category = activeSections[indexPath.row]
        
        switch category{
        case .popularMovie:
            cell.configureRowCell(title: "Popular this week", with: popularMovies, category: .popularMovie)
        case .topRated:
            cell.configureRowCell(title: "Top Rated", with: topRatedMovies, category: .topRated)
        case .upcoming:
            cell.configureRowCell(title: "Upcoming", with: upcomingMovies, category: .upcoming)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 283
    }
}

extension MovieListView: MovieCategoryRowCellDelegate{
    func cateforyButtonWasTapped(in cell: MovieCategoryRowCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let category = activeSections[indexPath.row]
        delegate?.didTapSeeAllButton(for: category)
    }
    
    func categoryCellDidSelectedMovie(at index: Int, in cell: MovieCategoryRowCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let category = activeSections[indexPath.row]
        delegate?.didSelectMovie(category: category, at: index)
    }
}

     

