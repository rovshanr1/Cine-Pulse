//
//  PopularMoviesVC.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 09.10.25.
//

import UIKit

class PopularMoviesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor  = UIColor(named: "Background")
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    //MARK: - Navigation Bar
    private func setupNavigationBar() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        let style = NavigationBarStyle.popularMovieStyle
        navigationController?.navigationBar.standardAppearance = style
        navigationController?.navigationBar.scrollEdgeAppearance = style
    }
    

}
