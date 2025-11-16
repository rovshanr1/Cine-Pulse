//
//  MovieVideoModel.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 23.10.25.
//

import Foundation

struct MovieVideoModel:Codable, Identifiable{
    let id: Int
    let results: [MovieVideoResult]
    
    struct MovieVideoResult: Codable{
        let key: String
        let site: String
        let name: String
        let type: String
    }
}
