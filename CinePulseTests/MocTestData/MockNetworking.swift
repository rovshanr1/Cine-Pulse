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
    case decodeError
}

final class MockNetworking: Networking {
    var result: Result<Data, Error>!

    func fetchData<T>(_ endpoint: any Endpoint) -> AnyPublisher<T, any Error> where T : Decodable {
        Future<T, any Error> { [result] promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        if T.self == MovieListModel.self {
                            let decoded = try decoder.decode(MovieListModel.self, from: data)
                            promise(.success(decoded as! T))
                        } else {
                            promise(.failure(MockError.decodeError))
                        }

                    } catch {
                        promise(.failure(error))
                    }

                case .failure(let failure):
                    promise(.failure(failure))

                case .none:
                    promise(.failure(MockError.networkError))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}



