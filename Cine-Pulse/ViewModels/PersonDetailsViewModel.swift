//
//  PersonDetailsViewModel.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 09.11.25.
//

import Foundation
import Combine

final class PersonDetailsViewModel:BaseViewModel{
    @Published var person: PersonModel?
    @Published var combinedCredits: CombinedCreditsModel?
    
    private func fetchPerson(id:Int){
        let endpoint = TMDBEndpoint.personDetails(id: id)
        
        super.fetchData(from: endpoint) { [weak self] (response: PersonModel) in
            guard let self = self else {return}
            self.person = response
        }
    }
    
    private func fetchtCombinedCredits(id:Int){
        let endpoint = TMDBEndpoint.personCombinedCredits(id: id)
        
        super.fetchData(from: endpoint) { [weak self] (response: CombinedCreditsModel) in
            guard let self = self else {return}
            self.combinedCredits = response
        }
    }
    
    func fetchPersonData(id: Int){
        fetchPerson(id: id)
        fetchtCombinedCredits(id: id)
    }
}
