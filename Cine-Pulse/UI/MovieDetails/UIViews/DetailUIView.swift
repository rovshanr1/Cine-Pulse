//
//  DetailUIView.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 17.10.25.
//

import UIKit
protocol DetailUIViewDelegate: AnyObject {
    func didScroll(withY offset: CGFloat)
}

class DetailUIView: UIView {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MoviePrimaryDetailsCell.self, forCellReuseIdentifier: "detailsCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "overviewCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    //Movie Details Model
    private var movieDetails: MovieDetailModel?
    private var movieCredits: MovieCreditsModel?
    
    private var isPrimaryTitleHidden: Bool = false

    //Strechy Header
    private var strechyHeader: StrechyTableHeaderView?

    weak var delegate: DetailUIViewDelegate?
    
    
    //MARK: - Initial
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
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
    
    private func setupViews(){
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
    
    public func configureDetailView(with details: MovieDetailModel){
        self.movieDetails = details
        
        strechyHeader?.configureStrechyHeader(with: details.backdropPathAsURL)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    public func configureCredits(with credits: MovieCreditsModel){
        self.movieCredits = credits
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MoviePrimaryDetailsCell {
            cell.configureDirector(with: credits)
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
        return movieDetails == nil ? 0 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as? MoviePrimaryDetailsCell else {
                fatalError("MoviePrimaryDetailsCell not found")
            }
            if let movieDetails = movieDetails {
                cell.configureDetailsCell(with: movieDetails)
            }
            cell.delegate = self
            cell.setTitleLabel(hidden: self.isPrimaryTitleHidden)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "overviewCell", for: indexPath)
            
            cell.textLabel?.text = movieDetails?.overview
            cell.textLabel?.font = .systemFont(ofSize: 16, weight: .regular)
            cell.textLabel?.numberOfLines = 0
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.tableHeaderView as? StrechyTableHeaderView else {
            return
        }
        
        header.scrollViewDidScroll(scrollView: scrollView)
        delegate?.didScroll(withY: scrollView.contentOffset.y)
    }
}



//MARK: - Poster tap gesture extension
extension DetailUIView: MoviePrimaryDetailsDelegate {
    func didTapPosterImage(_ image: UIImage?) {
        guard let image else { return }
        posterImageTapped(image)
    }
}
