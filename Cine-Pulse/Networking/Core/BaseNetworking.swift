//
//  BaseNetworking.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 04.10.25.
//

import Foundation
import Combine

protocol Networking{
    func fetchData<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, Error>
}

struct BaseNetworking: Networking {
    func fetchData<T>(_ endpoint: any Endpoint) -> AnyPublisher<T, Error> where T : Decodable {
        do{
            let request = try endpoint.asURLRequest()
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap{ output in
                    guard let httpResponse = output.response as? HTTPURLResponse else {
                        print("invalid response")
                        throw NetworkErrors.invalidResponse
                    }
                    
                    guard (200...299).contains(httpResponse.statusCode) else{
                        if httpResponse.statusCode == 404 {
                            throw NetworkErrors.notFound
                        }
                        throw NetworkErrors.invalidResponse
                    }
                    return output.data
                }
                .decode(type: T.self, decoder: {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    return decoder
                    
                }())
                .mapError{ error -> Error in
                    if let decodingError = error as? DecodingError{
                        print("Decoding Error: \(decodingError)")
                        return decodingError
                    }
                    print("Decoding faild: \(error)")
                    return NetworkErrors.decodingError(error)
                    
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }catch{
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}




