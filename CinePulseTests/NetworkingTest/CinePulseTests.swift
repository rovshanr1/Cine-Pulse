//
//  CinePulseTests.swift
//  CinePulseTests
//
//  Created by Rovshan Rasulov on 05.10.25.
//

import XCTest
import Combine
@testable import Cine_Pulse

final class CinePulseTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
    var networking: BaseNetworking!
    
    override func setUp(){
        super.setUp()
        networking = BaseNetworking()
    }
    
    func testMovieEndpoint() {
        let expextation = XCTestExpectation(description: "Fetch movie list from TMDB")
        
        networking.fetchData(TMDBEndpoint.movieList(query: "inception", page: 1))
            .sink(receiveCompletion: { completion in
                if case .failure(let failure) = completion {
                    XCTFail("Request failed with error: \(failure)")
                }
                expextation.fulfill()
            }) { (response: MovieListModel) in
                XCTAssertFalse(response.results.isEmpty, "Movie list should not be empty")
                print("Received movie list: \(response.results.count) ")
            }
            .store(in: &cancellables)
        
        wait(for: [expextation], timeout: 5)
    }
    
    func testMovieDetails() {
        let expectation = XCTestExpectation(description: "Fetch movie deteils from TMDB")
        
        networking.fetchData(TMDBEndpoint.movieDetails(id: 550))
            .sink(receiveCompletion: { completion in
                if case .failure(let failure) = completion {
                    XCTFail("Request failed with error: \(failure)")
                }
                expectation.fulfill()
            }, receiveValue: {( response: MovieDetailModel) in
                XCTAssertFalse(response.genres.isEmpty, "Movie genres should not be empty")
                print("Recived genre list: \(response.genres.count)")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
}
