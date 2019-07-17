//
//  NetworkCoordinatorTests.swift
//  CoinWatcherSDKTests
//
//  Created by Adi Ravikumar on 7/16/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import XCTest
@testable import CoinWatcherSDK

class NetworkCoordinatorTests: XCTestCase {

    /// Validate that the assignment of all the dependencies work
    func testNetworkCoordinatorSetup() {
        let testBaseURL = "test"
        let networkCoordinator = NetworkCoordinator(with: URLSession.init(), baseURL: testBaseURL)
        XCTAssertNotNil(networkCoordinator.urlSession)
        XCTAssertEqual(networkCoordinator.baseURL, testBaseURL)
    }
}
