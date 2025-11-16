//
//  URLExtension.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 10.11.25.
//

import Foundation

extension URL {
    static let tmdbBase =  URL(string: "https://image.tmdb.org/t/p/w500")!
    
    static func tmdbImage(path: String?) -> URL? {
        guard let path, !path.isEmpty else { return nil }
        return tmdbBase.appendingPathComponent(path)
    }
}
