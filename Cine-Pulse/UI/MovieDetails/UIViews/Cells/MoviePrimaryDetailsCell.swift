//
//  MoviePrimaryDetailsCell.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 21.10.25.
//

import UIKit
import Kingfisher

protocol MoviePrimaryDetailsDelegate: AnyObject{
    func didTapPosterImage(_ image: UIImage?)
    func didTapVideoButton(withKey key: String)
}

class MoviePrimaryDetailsCell: UITableViewCell {
    var onTogleExpand: (() -> Void)?
    
    //Stored Properties
    weak var delegate: MoviePrimaryDetailsDelegate?
    private var videoKey: String?
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let directorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .textColorOne
        return label
    }()
    
    private let videoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("▶︎ TRAILER", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        button.backgroundColor = .buttonBackground
        button.tintColor = .buttonTextColorOne
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return button
    }()
    
    private let runtime: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 5
        label.textColor = .overviewLabel
        label.isUserInteractionEnabled = true
       return label
    }()
    
    private let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .gray.withAlphaComponent(0.7)
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return divider
    }()
    
    private let ratingChart: RatingChartView = {
        let chart = RatingChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.heightAnchor.constraint(equalToConstant: 196).isActive = true
        return chart
    }()
    
    
    //Stack Views
    private lazy var releaseDateAndDirectorStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [releaseDateLabel, directorLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private lazy var videoButtonAndRuntimeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [videoButton, runtime])
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    private lazy var infoLeftSideStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, releaseDateAndDirectorStackView, videoButtonAndRuntimeStackView])
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [infoLeftSideStackView,posterImageView])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .top
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [infoStackView, overviewLabel, divider, ratingChart])
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupGesture()
        setupAction()
        setupOverviewTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupStyle()
    }
    
    private func setupUI(){
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(mainStackView)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            posterImageView.widthAnchor.constraint(equalToConstant: 110),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5)
            
        ])
    }
    
    private func setupStyle() {
        posterImageView.layer.cornerRadius = 8
        posterImageView.layer.borderWidth = 0.5
        posterImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
    }
    
    private func setupAction(){
        videoButton.addTarget(self, action: #selector(didTapVideoButton), for: .touchUpInside)
    }
    
    
    @objc private func didTapVideoButton(){
        guard let key = videoKey else { return }
        delegate?.didTapVideoButton(withKey: key)
    }
    
    private func setupOverviewTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOverviewLabel))
        overviewLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapOverviewLabel(){
        onTogleExpand?()
    }
    
    func setTitleLabel(hidden: Bool){
        let targetAlpha: CGFloat = hidden ? 0.0 : 1.0
        if self.titleLabel.alpha == targetAlpha {
            return
        }
        
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       animations: {self.titleLabel.alpha = targetAlpha},
                       completion: nil
        )
    }
}

//MARK: - Configuration methods
extension MoviePrimaryDetailsCell{
    func configureDirector(with credits: MovieCreditsModel){
        if let directorName = credits.director{
            directorLabel.text = "\(directorName)"
            directorLabel.isHidden = false
        }else{
            directorLabel.isHidden = true
        }
    }
    
    func configureDetailsCell(with movie: MovieDetailModel, isExpanded: Bool) {
        titleLabel.text = movie.title
        releaseDateLabel.text = "\(movie.extractYear) • Directed by"
        
        if let posterPath = movie.posterPathAsURL {
            posterImageView.kf.setImage(with: posterPath)
        }
        
        runtime.text = "\(movie.runtime) mins"
        overviewLabel.text = movie.overview
       
        overviewLabel.numberOfLines = isExpanded ? 0 : 5
        
        ratingChart.onBarTapped = { reting, count in }
    }
    
    func configureRatingChart(with rating: [Int]){
        ratingChart.chartConfigure(with: rating)
    }
    
    func configureVideCell(with video: MovieVideoModel){
        if let trailer = video.results.first(where: { $0.type == "Trailer"  && $0.site == "Youtube"}) {
            self.videoKey = trailer.key
            videoButton.isHidden = false
        }else{
            if let anyVideo = video.results.first(where: { $0.site == "YouTube"}) {
                self.videoKey = anyVideo.key
                videoButton.isHidden = false
                videoButton.setTitle("▶︎ TRAILER", for: .normal)
           }else{
                self.videoKey = nil
                videoButton.isEnabled = false
            }
        }
    }
}

//MARK: - Poster Image tap gesture method
extension MoviePrimaryDetailsCell{
    private func setupGesture(){
        if let gesture = posterImageView.gestureRecognizers{
            for g in gesture {
                posterImageView.removeGestureRecognizer(g)
            }
        }
        let top = UITapGestureRecognizer(target: self, action: #selector(didTapPoster))
        posterImageView.addGestureRecognizer(top)
    }
    
    @objc private func didTapPoster(){
        delegate?.didTapPosterImage(posterImageView.image)
    }
}
