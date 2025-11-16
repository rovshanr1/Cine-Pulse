//
//  CombinedCreditsModel.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 09.11.25.
//

import Foundation

struct CombinedCreditsModel: Codable{
    let cast: [Cast]
    let crew: [Crew]
    
    struct Cast: Codable{
        let adult: Bool
        let backdropPath: String?
        let genreIds: [Int]
        let id: Int
        let title: String?
        let overview: String
        let posterPath: String?
    }
    
    struct Crew: Codable{
        let adult: Bool
        let backdropPath: String?
        let genreIds: [Int]
        let id: Int
        let title: String?
        let overview: String
        let posterPath: String?
    }
}


extension CombinedCreditsModel.Cast{
    var combinedCreditsCastPoster: URL? {
        .tmdbImage(path: posterPath)
    }
}

extension CombinedCreditsModel.Crew{
    var combinedCreditsCrewPoster: URL? {
        .tmdbImage(path: posterPath)
    }
}
