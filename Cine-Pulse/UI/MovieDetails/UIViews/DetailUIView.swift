//
//  DetailUIView.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 17.10.25.
//

import UIKit
protocol DetailUIViewDelegate: AnyObject {
    func didScroll(withY offset: CGFloat)
    func didTapWatchTrailer(withKey key: String)
    func didTapPerson(withID pesonID: Int)
}

class DetailUIView: UIView{
    //UI Elements
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MoviePrimaryDetailsCell.self, forCellReuseIdentifier: "detailsCell")
        tableView.register(SelectedTabCell.self, forCellReuseIdentifier: "tabContentCell")
        tableView.register(SelectedTabContentCell.self, forCellReuseIdentifier: "SelectedTabContentCell")
        tableView.register(ShowMoreButtonCell.self, forCellReuseIdentifier: "ShowMoreButtonCell")
        tableView.register(GenresCell.self, forCellReuseIdentifier: "GenreCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    
    //Models
    private var movieDetails: MovieDetailModel?
    private var movieCredits: MovieCreditsModel?
    private var movieVideos: MovieVideoModel?
    private var movieRatings: [Int]?
    private var activeTab: DetailTab = .cast
    
    //control propertys
    private var isPrimaryTitleHidden: Bool = false
    private var isOverviewExpanded: Bool = false
    private var isContentExpanded: Bool = false
    private var defaultContentLimit = 10
    
    
    
    //Strechy Header
    private var strechyHeader: StrechyTableHeaderView?
    
    weak var delegate: DetailUIViewDelegate?
    
    
    //MARK: - Initial
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let header = tableView.tableHeaderView else { return }
        let headerHeight = AspectRatio.sixteenByNine.height(for: self.frame.size.width)
        
        var headerFrame = header.frame
        
        if headerFrame.height != headerHeight {
            headerFrame.size.height = headerHeight
            header.frame = headerFrame
            tableView.tableHeaderView = header
        }
    }
    
    //MARK: - Constraints
    private func setupUI(){
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        let header = StrechyTableHeaderView(frame: CGRect(x: 0, y: 0,
                                                          width: self.frame.size.width,
                                                          height: self.frame.size.width))
        self.strechyHeader = header
        tableView.tableHeaderView = header
    }
    
    @objc private func toggleContentExpansion(){
        guard let credits = movieCredits, let genre = movieDetails else {return}
        
        let limit = defaultContentLimit
        
        let totalCount: Int = {
            switch activeTab{
            case .cast:
                return credits.cast.count
            case .crew:
                return credits.crew.count
            case .genre:
                return genre.genres.count
            }
        }()
        
        guard totalCount > limit else {return}
        
        self.isContentExpanded.toggle()
        
        let indexPaths: [IndexPath] = (limit..<totalCount).map { dataIndex in
            IndexPath(row: dataIndex + 2, section: 0)
        }
        
        
        tableView.performBatchUpdates ({
            if isContentExpanded{
                tableView.insertRows(at: indexPaths, with: .fade)
            }else{
                tableView.deleteRows(at: indexPaths, with: .fade)
            }
        }) { _ in
            if !self.isContentExpanded{
                let tabIndexPath = IndexPath(row: 1, section: 0)
                if self.tableView.numberOfRows(inSection: 0) > tabIndexPath.row{
                    self.tableView.scrollToRow(at: tabIndexPath, at: .top, animated: true)
                }
            }
        }
    }
}

//MARK: - Public Methods
extension DetailUIView{
    public func configureDetailView(with details: MovieDetailModel){
        self.movieDetails = details
        strechyHeader?.configureStrechyHeader(with: details.backdropPathAsURL)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    public func configureCredits(with credits: MovieCreditsModel){
        self.movieCredits = credits
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    public func configureVideos(with videos: MovieVideoModel){
        self.movieVideos = videos
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MoviePrimaryDetailsCell {
            cell.configureVideCell(with: videos)
        }
    }
    
    public func configureRatings(with rating: [Int]){
        self.movieRatings = rating
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MoviePrimaryDetailsCell {
            cell.configureRatingChart(with: rating)
        }
    }
    
    public func configureActiveTab(tab: DetailTab){
        self.activeTab = tab
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    public func setPrimaryTitle(hidden: Bool){
        self.isPrimaryTitleHidden = hidden
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MoviePrimaryDetailsCell {
            cell.setTitleLabel(hidden: self.isPrimaryTitleHidden)
        }
    }
}

//MARK: - Table View Delegate, DataSource and Scroll View Delegate extension
extension DetailUIView: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard movieDetails != nil else {return 0}
        
        var rowCount = 2
        guard let credits = movieCredits, let genre = movieDetails else {return rowCount}
        
        
        let limit = defaultContentLimit
        
        let totalCount: Int = {
            switch activeTab{
            case .cast:
                return credits.cast.count
            case .crew:
                return credits.crew.count
            case .genre:
                return genre.genres.count
            }
        }()
        
        let rowToShow = isContentExpanded ? totalCount : min(totalCount, limit)
        rowCount += rowToShow
        
        if totalCount > limit{
            rowCount += 1
        }
        
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as? MoviePrimaryDetailsCell else {
                fatalError("MoviePrimaryDetailsCell not found")
            }
            
            if let movieDetails = movieDetails {
                cell.configureDetailsCell(with: movieDetails, isExpanded: self.isOverviewExpanded)
            }
            if let movieCredits = movieCredits{
                cell.configureDirector(with: movieCredits)
            }
            if let movieVideos = movieVideos{
                cell.configureVideCell(with: movieVideos)
            }
            if let movieRatings = movieRatings{
                cell.configureRatingChart(with: movieRatings)
            }
            
            cell.delegate = self
            cell.setTitleLabel(hidden: self.isPrimaryTitleHidden)
            
            cell.onTogleExpand = { [weak self, weak cell] in
                guard let self = self, let cell = cell else { return }
                
                self.isOverviewExpanded.toggle()
                self.tableView.beginUpdates()
                
                if let movieDetails = movieDetails {
                    cell.configureDetailsCell(with: movieDetails, isExpanded: self.isOverviewExpanded)
                }
                
                self.tableView.endUpdates()
            }
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tabContentCell", for: indexPath) as? SelectedTabCell else {
                fatalError("MovieTabContentCell  not found")
            }
            cell.delegate = self
            cell.configureSelectedTab(withc: activeTab)
            return cell
            
        default:
            guard let credits = movieCredits, let genre = movieDetails else {
                return UITableViewCell()
            }
            
            let totalCount: Int = {
                switch activeTab{
                case .cast:
                    return credits.cast.count
                case .crew:
                    return credits.crew.count
                case .genre:
                    return genre.genres.count
                }
            }()
            
            let limit = defaultContentLimit
            let rowToShow = isContentExpanded ? totalCount : min(totalCount, limit)
            
            let dataIndex = indexPath.row - 2
            
            if dataIndex < rowToShow{
                
                switch activeTab{
                case .cast:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedTabContentCell", for: indexPath) as? SelectedTabContentCell else {
                        fatalError("SelectedTabContentCell not found")
                    }
                    if let castMember = credits.cast[safe: dataIndex] {
                        cell.contentDisplayView.castConfigure(castMember)
                    }
                    return cell
                case .crew:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedTabContentCell", for: indexPath) as? SelectedTabContentCell else {
                        fatalError("SelectedTabContentCell not found")
                    }
                    if let crewMember = credits.crew[safe: dataIndex] {
                        cell.contentDisplayView.crewConfigure(crewMember)
                    }
                    return cell
                case .genre:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell", for: indexPath) as? GenresCell else{
                         fatalError("GenreCell not found")
                     }
                    if let genres = genre.genres[safe: dataIndex]{
                        cell.configureGenreLabel(genres)
                    }
                    return cell
                }
                
                
            } else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShowMoreButtonCell", for: indexPath) as? ShowMoreButtonCell else {
                    fatalError("ShowMoreButtonCell not found")
                }
                let remainingCount = totalCount - limit
                
                let buttonTitle: String
                if isContentExpanded{
                    buttonTitle = "Show Less"
                }else{
                    buttonTitle = "Show \(remainingCount) more"
                }
                
                cell.configureMoreButton(title: buttonTitle )
                cell.delegate = self
                return cell
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.tableHeaderView as? StrechyTableHeaderView else {
            return
        }
        
        header.scrollViewDidScroll(scrollView: scrollView)
        delegate?.didScroll(withY: scrollView.contentOffset.y)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row > 1 else { return }
        
        let dataIndex = indexPath.row - 2
        
        guard let credits = movieCredits else { return }
        
        var personID: Int?
        
        switch activeTab {
        case .cast:
            if let castMember = credits.cast[safe: dataIndex] {
                personID = castMember.id
            }
        case .crew:
            if let crewMember = credits.crew[safe: dataIndex] {
                personID = crewMember.id
            }
        default:
            break
        }
        
        if let personID = personID {
            delegate?.didTapPerson(withID: personID)
        }
    }
    
}

//MARK: - Poster tap gesture delegate
extension DetailUIView: MoviePrimaryDetailsDelegate {
    func didTapVideoButton(withKey key: String) {
        delegate?.didTapWatchTrailer(withKey: key)
    }
    
    func didTapPosterImage(_ image: UIImage?) {
        guard let image else { return }
        posterImageTapped(image)
    }
}

//MARK: - Selected content tab delegate
extension DetailUIView: SelectedTabCellDelegate {
    func didSelectTab(_ movie: DetailTab) {
        self.activeTab = movie
        tableView.reloadData()
    }
}

extension DetailUIView: ShowMoreButtonDelegate{
    func didTapMoreButton() {
        self.toggleContentExpansion()
    }
}

