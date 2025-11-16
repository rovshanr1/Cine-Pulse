//
//  CollectionExtension.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 04.11.25.
//

import Foundation

extension Collection{
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

