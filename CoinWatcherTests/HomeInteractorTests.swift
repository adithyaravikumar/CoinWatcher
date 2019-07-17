//
//  HomeInteractorTests.swift
//  CoinWatcherTests
//
//  Created by Adi Ravikumar on 7/16/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import XCTest
import CoinWatcherSDK
@testable import CoinWatcher

class HomeInteractorTests: XCTestCase {
    
    private var currentCoinData: CurrentCoinData!
    private var historicCoinData: HistoricCoinData!
    private var homeInteractor: HomeInteractor!
    private var testExpectation: XCTestExpectation!

    override func setUp() {
        currentCoinData = nil
        historicCoinData = nil
        homeInteractor = HomeInteractor(withDisplayLayer: self, coinSource: MockCoinWatcher())
        testExpectation = XCTestExpectation(description: "test expectation")
    }
    
    func testCoinSourceDelegateAssignment() {
        
        // When the view appears, the view controller calls the viewWillAppear() function on the interactor which will make the interactor subscribe to the coin watcher's updates
        homeInteractor.viewWillAppear()
        XCTAssertNotNil(homeInteractor.coinSource.delegate)
        
        // When the view disappears, the view controller calls the viewWillDisappear() function on the interactor which will make the interactor unsubscribe from the coin watcher's updates
        homeInteractor.viewWillDisappear()
        XCTAssertNil(homeInteractor.coinSource.delegate)
    }
    
    // Test that the correct delegates are fired when the current coin price is fetched periodically
    func testCurrentPriceFetchFromCoinWatching() {
        XCTAssertNil(currentCoinData)
        homeInteractor.viewWillAppear()
        wait(for: [testExpectation], timeout: 5.0)
        XCTAssertNotNil(currentCoinData)
    }
    
    // Test that the correct delegates are fired when the current coin price is MANUALLY fetched
    func testCurrentPriceFetchFromManualIntervention() {
        XCTAssertNil(currentCoinData)
        homeInteractor.viewWillAppear()
        homeInteractor.fetchLatestPrice()
        wait(for: [testExpectation], timeout: 5.0)
        XCTAssertNotNil(currentCoinData)
    }
    
    // Test that the correct delegates are fired when the historic coin price is fetched
    func testHistoricPriceFetch() {
        XCTAssertNil(historicCoinData)
        homeInteractor.viewWillAppear()
        homeInteractor.fetchHistoricPrices(from: Date(), to: Date(), inCurrency: .usd)
        wait(for: [testExpectation], timeout: 5.0)
        XCTAssertNotNil(historicCoinData)
    }
}

extension HomeInteractorTests: HomeDisplay {
    
    func displayCurrentPriceChange(with coinData: CurrentCoinData) {
        currentCoinData = coinData
        testExpectation.fulfill()
    }
    
    func displayHistoricPriceChange(for historicData: HistoricCoinData) {
        historicCoinData = historicData
        testExpectation.fulfill()
    }
    
    func displayGenericErrorAlert() { }
}
