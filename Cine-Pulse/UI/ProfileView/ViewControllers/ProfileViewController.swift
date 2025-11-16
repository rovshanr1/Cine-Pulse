//
//  ProfileViewController.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 15.11.25.
//

import UIKit

class ProfileViewController: UIViewController {
    //ContentView
    private var contentView = ProfileUIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI(){
        navigationItem.title = "Rovshan"
        
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
}
