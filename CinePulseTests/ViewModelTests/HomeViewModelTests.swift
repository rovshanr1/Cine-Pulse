//
//  HomeViewModelTests.swift
//  CinePulseTests
//
//  Created by Rovshan Rasulov on 11.10.25.
//

import XCTest
import Combine
@testable import Cine_Pulse

struct MovieListModel: Codable {
    let results: [Movie]
    
    struct Movie: Codable, Identifiable, Equatable {
        let id: Int
        let title: String
    }
}

final class HomeViewModelTests: XCTestCase {

    var sut: HomeViewModel!
    var mockNetworking: MockNetworking!
    private var cancellables: Set<AnyCancellable>!
    
    
    override func setUp() {
        super.setUp()
        mockNetworking = MockNetworking()
        sut = HomeViewModel(networking: mockNetworking)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        mockNetworking = nil
        cancellables = nil
        super.tearDown()
    }
    
    
    func testFetchMovies_WhenFailed_ShouldAssignError() {
        let expectetion = XCTestExpectation(description: "The films are expected to be released successfully.")
        
        let error = MockError.networkError
        mockNetworking.result = .failure(error)
        
        sut.error = "Initial Error"
        
        var errorHistory: [String?] = []
        
        sut.$error
            .dropFirst()
            .sink { errorMessage in
                
                errorHistory.append(errorMessage)
                
                if errorMessage == error.localizedDescription {
                    expectetion.fulfill( )
                }
            }
            .store(in: &cancellables)
        
        sut.fetchMovies()
        
        wait(for: [expectetion], timeout: 1.0)
        
        XCTAssertEqual(sut.error, error.localizedDescription)
        XCTAssertTrue(self.sut.movieList.isEmpty)
        XCTAssertFalse(self.sut.isLoading)
    }
    
    
    func testIsLoading_WhenFetching_ShouldBeTrue() {
        let expectetion = XCTestExpectation(description: "The films are expected to be released successfully.")
        
        
        let mockResponse = MovieListModel(results: [])
        let mockData = try! JSONEncoder().encode(mockResponse)
        mockNetworking.result = .success(mockData)
        
        var loadingStates: [Bool] = []
        
        sut.$isLoading
            .sink { state in
                loadingStates.append(state)
                
                if !state && loadingStates.count > 1 {
                    expectetion.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.fetchMovies( )
        
        wait(for: [expectetion], timeout: 1.0)
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(loadingStates, [false, true, false])
    }
 
    
}
