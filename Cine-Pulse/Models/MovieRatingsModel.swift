//
//  MovieRatingsModel.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 26.10.25.
//

import Foundation

struct MovieRatingsModel: Codable{
    let rating: Double?
    let votes: Int?

    let distribution: [String: Int]?
    
    func getRatingDistributionArray() -> [Int] {
        guard let distribution = distribution else{
            return Array(repeating: 0, count: 10)
        }
        var ratingArray: [Int] = []
        for i in 1...10 {
            let key = "\(i)"
            let coubnt = distribution[key] ?? 0
            ratingArray.append(coubnt)
        }
        return ratingArray
    }
    
}
