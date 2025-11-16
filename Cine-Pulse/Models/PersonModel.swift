//
//  PersonModel.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 09.11.25.
//

import Foundation

struct PersonModel: Codable, Identifiable{
    let adult: Bool
    let biography: String
    let id: Int
    let imdbID: String?
    let name: String
    let profilePath: String?
}


extension PersonModel {
    var personProfilePath: URL? {.tmdbImage(path: profilePath)}
}
