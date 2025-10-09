//
// Secrets.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 04.10.25.
//

import Foundation

enum Secrets{
    static var tmdbAccessToken: String{
        Bundle.main.infoDictionary?["TMDB_ACCESS_TOKEN"] as? String ?? ""
    }
}
