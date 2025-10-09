//
//  NavigationBarStyle.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 09.10.25.
//

import UIKit

struct NavigationBarStyle{
    
    static var cinePulseStyle: UINavigationBarAppearance{
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "NavigationBarBackground")
        return appearance
    }
    
    static var popularMovieStyle: UINavigationBarAppearance{
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        return appearance
    }
}
