//
//  CoinWatcherTests.swift
//  CoinWatcherSDKTests
//
//  Created by Adi Ravikumar on 7/16/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import XCTest
@testable import CoinWatcherSDK

class CoinWatcherTests: XCTestCase {
    private let testCoinPricing = CoinPricing(code: "test", rate: "test", description: "test")
    private var coinWatcher: CoinWatcher!
    private var currentCoinData: CurrentCoinData!
    private var historicCoinData: HistoricCoinData!
    private var apiError: Error!
    
    override func setUp() {
        currentCoinData = nil
        historicCoinData = nil
        apiError = nil
        coinWatcher = CoinWatcher(with: MockCoinWatcherDependencies())
        coinWatcher.delegate = self
    }

    override func tearDown() {
        coinWatcher.delegate = nil
        coinWatcher = nil
    }
    
    /// Validate that the timer starts/stops based on watching logic
    func testTimerLogic() {
        // Once we start watching, the timer should be non nil
        coinWatcher.startWatching()
        XCTAssertNotNil(coinWatcher.timer)
        
        // Once we stop watching, the timer should be nil
        coinWatcher.stopWatching()
        XCTAssertNil(coinWatcher.timer)
    }
    
    /// Validate that the delegate assignment works
    func testDelegationAssignment() {
        XCTAssertNotNil(coinWatcher.delegate)
    }
    
    /// Validate that the delegation of the current price fetch works
    func testCurrentPriceDelegation() {
        let bitCoinPriceIndex = BitcoinPriceIndex(bitcoinUSPricing: testCoinPricing, bitcoinUKPricing: testCoinPricing, bitcoinEUPricing: testCoinPricing)
        coinWatcher.delegate?.didUpdate(coinData: CurrentCoinData(bpi: bitCoinPriceIndex))
        
        XCTAssertNotNil(currentCoinData)
        XCTAssertEqual(currentCoinData.bpi.bitcoinEUPricing.code, bitCoinPriceIndex.bitcoinEUPricing.code)
        XCTAssertEqual(currentCoinData.bpi.bitcoinEUPricing.rate, bitCoinPriceIndex.bitcoinEUPricing.rate)
        XCTAssertEqual(currentCoinData.bpi.bitcoinEUPricing.description, bitCoinPriceIndex.bitcoinEUPricing.description)
    }
    
    /// Validate that the delegation of the historic price fetch works
    func testHistoricPriceDelegation() {
        coinWatcher.delegate?.didFetch(historicData: HistoricCoinData(bpi: ["test": 20.0]), inCurrency: .eur)
        XCTAssertNotNil(historicCoinData)
    }
    
    /// Validate that the delegation of error works
    func testErrorDelegation() {
        coinWatcher.delegate?.didFail(with: TestingError.sampleError)
        XCTAssertNotNil(apiError)
    }
}

extension CoinWatcherTests: CoinWatchingDelegate {
    func didUpdate(coinData: CurrentCoinData) {
        currentCoinData = coinData
    }
    
    func didFetch(historicData: HistoricCoinData, inCurrency currencyType: CurrencyType) {
        historicCoinData = historicData
    }
    
    func didFail(with error: Error) {
        apiError = error
    }
}
