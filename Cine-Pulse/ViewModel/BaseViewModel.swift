//
//  BaseViewModel.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 16.10.25.
//

import Foundation


protocol BaseViewModel{
    var movieList: [MovieListModel.Movie]  { get set }
    var error: String? {get set}
    var isLoading: Bool {get set}
    
}

extension BaseViewModel{
    func movie(at index: Int) -> MovieListModel.Movie? {
        guard movieList.indices.contains(index) else {
            return nil
        }
        
        return movieList[index]
    }
}
