//
//  CoinWatcherDependenciesTests.swift
//  CoinWatcherTests
//
//  Created by Adi Ravikumar on 7/16/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import XCTest
@testable import CoinWatcherSDK

class CoinWatcherDependenciesTests: XCTestCase {

    func testCoinWatcherDependencies() {
        let coinWatcherDependencies = DefaultCoinWatcherDependencies()
        XCTAssertEqual(coinWatcherDependencies.refreshInterval, DefaultCoinWatcherDependencies.Constants.defaultRefreshInterval)
        XCTAssertEqual(coinWatcherDependencies.baseUrl, DefaultCoinWatcherDependencies.Constants.defaultBaseUrl)
        XCTAssertEqual(coinWatcherDependencies.currencyType, DefaultCoinWatcherDependencies.Constants.defaultCurrencyType)
    }
}
