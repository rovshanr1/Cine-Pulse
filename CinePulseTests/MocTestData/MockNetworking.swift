//
//  MockNetworking.swift
//  CinePulseTests
//
//  Created by Rovshan Rasulov on 11.10.25.
//

import Foundation
import Combine
@testable import Cine_Pulse

enum MockError: Error {
    case networkError
}

class MockNetworking: Networking{
    var result: Result<Data, Error>!
    
    func fetchData<T>(_ endpoint: any Endpoint) -> AnyPublisher<T, any Error> where T : Decodable {
        return Future<T, Error> { promise in
            switch self.result {
            case .success(let data):
                do{
                    let decode = JSONDecoder()
                    decode.keyDecodingStrategy = .convertFromSnakeCase
                    let decodeObj = try decode.decode(T.self, from: data)
                    promise(.success(decodeObj))
                }catch{
                    promise(.failure(error))
                }
            case .failure(let failure):
                promise(.failure(failure))
            case .none:
                promise(.failure(MockError.networkError))
            }
        }
        .eraseToAnyPublisher()
    }
}
