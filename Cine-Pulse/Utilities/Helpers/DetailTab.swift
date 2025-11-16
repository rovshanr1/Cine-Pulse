//
//  DetailTab.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 02.11.25.
//

import Foundation


enum DetailTab{
    case cast
    case crew
    case genre
    
    var tableLabel: String {
        switch self {
        case .cast:
            return "Cast"
        case .crew:
            return "Crew"
        case .genre:
            return "Genre"
        }
    }
}
