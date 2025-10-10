//
//  HomeViewModelTests.swift
//  CinePulseTests
//
//  Created by Rovshan Rasulov on 11.10.25.
//

import XCTest
import Combine
@testable import Cine_Pulse

final class HomeViewModelTests: XCTestCase {

    var sut: MovieListViewModel!
    var mockNetworking: MockNetworking!

    private var cancellables: Set<AnyCancellable>!
    
    
    override func setUp() {
        super.setUp()
        mockNetworking = MockNetworking()
        sut = MovieListViewModel(networking: mockNetworking)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        mockNetworking = nil
        cancellables = nil
        super.tearDown()
    }
}
