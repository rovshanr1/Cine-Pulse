//
//  MovieDetailModel.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 05.10.25.
//

import Foundation

struct MovieDetailModel: Codable{
    let adult: Bool
    let backdropPath: String?
    let budget: Int
    let genres: [Genre]
    let homepage: String?
    let id: Int
    let imdbId: String?
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let runtime: Int
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let title: String
    let voteAverage: Double
    
    
    struct Genre: Codable{
        let id: Int
        let name: String
    }
    
    struct ProductionCompany: Codable{
        let id: Int
        let logoPath: String?
        let name: String
        let originCountry: String
    }
    
    struct ProductionCountry: Codable{
        let iso31661: String
        let iso31662: String?
        let name: String
    }
    
    struct SpokenLanguage: Codable{
        let englishName: String?
        let iso6391: String
        let name: String
    }
}

