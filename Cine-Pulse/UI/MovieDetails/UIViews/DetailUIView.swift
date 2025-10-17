//
//  DetailUIView.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 17.10.25.
//

import UIKit

class DetailUIView: UIView {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    private let vm = DetailViewModel()
    
    //MARK: - Initial
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews(){
        addSubview(tableView)
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.frame = self.bounds
    }
}


//extension DetailUIView: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return vm.movieDetails.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        
//        return cell
//    }
//}
