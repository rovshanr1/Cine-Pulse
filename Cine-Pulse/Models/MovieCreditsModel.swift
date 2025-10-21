//
//  MovieCreditsModel.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 21.10.25.
//

import Foundation

struct MovieCreditsModel: Codable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
    
    struct Cast: Codable {
        let id: Int
        let name: String
        let character: String?
    }
    
    struct Crew: Codable {
        let id: Int
        let name: String
        let job: String
        let department: String
    }
    
}

extension MovieCreditsModel {
    var director: String?{
        crew.first(where: { $0.job == "Director" })?.name
    }
}
