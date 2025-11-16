//
//  CinePulseTabBarController.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 29.10.25.
//

import UIKit

class CinePulseTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        minimizingTabBar()
    }
    
    
    private func setupTabs() {
        viewControllers = TabItem.allCases.map{ tab in
        let vc = tab.viewController
            vc.tabBarItem = tab.tabBarITem
            return UINavigationController(rootViewController: vc)
        }
    }
    
    private func minimizingTabBar() {
        if #available(iOS 26.0, *) {
            self.tabBarMinimizeBehavior = .onScrollDown
        } else {
            // Fallback on earlier versions
        }
    }
}


extension CinePulseTabBarController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}


