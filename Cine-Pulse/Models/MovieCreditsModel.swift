//
//  MovieCreditsModel.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 21.10.25.
//

import Foundation

struct MovieCreditsModel: Codable, Identifiable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
    
    struct Cast: Codable {
        let id: Int
        let name: String
        let character: String?
        let profilePath: String?
        let originalName: String
    }
    
    struct Crew: Codable {
        let id: Int
        let name: String
        let profilePath: String?
        let department: String
        let job: String
    }
}

extension MovieCreditsModel {
    var director: String?{
        crew.first(where: { $0.job == "Director" })?.name
    }
}

extension MovieCreditsModel.Crew {
    var crewProfilePath: URL? {
        .tmdbImage(path: profilePath)
    }
}

extension MovieCreditsModel.Cast {
    var castProfilePath: URL? {
        .tmdbImage(path: profilePath)
    }
}
