//
//  BaseViewModel.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 16.10.25.
//

import Foundation
import Combine


class BaseViewModel: ObservableObject{
    @Published var error: String?
    @Published var isLoading: Bool = false
    
    private let networking: Networking
    var cancellables: Set<AnyCancellable> = []
    
    init(networking: Networking = BaseNetworking()) {
        self.networking = networking
    }
    
    public func fetchData<R: Decodable>(from endpoint: any Endpoint, handler: @escaping (R) -> Void) {
        isLoading = true
        error = nil
        
        networking.fetchData(endpoint)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] complation in
                guard let self = self else { return }
                
                
                if case .failure(let error) = complation {
                    if let networkError = error as? NetworkErrors, networkError == .notFound{
                        print("(404) Not Found")
                    }else{
                        self.error = error.localizedDescription
                    }
                }
                
                self.isLoading = false
            } receiveValue: { (response: R) in
                handler(response)
            }
            .store(in: &cancellables)
    }
}
