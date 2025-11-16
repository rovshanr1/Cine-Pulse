//
//  TabItem.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 31.10.25.
//

import UIKit


enum TabItem: CaseIterable{
    case home
    case search
    case profile
    
    var viewController: UIViewController{
        switch self {
            case .home:
            return CinePulseViewController()
        case .search:
            return SearchMoviesViewController()
        case .profile:
            return ProfileViewController()
        }
    }
    
    var tabBarITem: UITabBarItem{
        switch self{
        case .home:
            UITabBarItem(title: nil, image: UIImage(systemName: "square.stack"), tag: 0)
        case .search:
            UITabBarItem(tabBarSystemItem: .search, tag: 1)
        case .profile:
            UITabBarItem(title: nil, image: UIImage(systemName: "person"), tag: 2)
        }
    }
}
