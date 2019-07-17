//
//  HistoricPricesInteractorTests.swift
//  CoinWatcherTests
//
//  Created by Adi Ravikumar on 7/16/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import XCTest
import CoinWatcherSDK
@testable import CoinWatcher

class HistoricPricesInteractorTests: XCTestCase {
    
    private var historicPricesInteractor: HistoricalPriceInteractor!
    private var testExpectation: XCTestExpectation!
    private var tableModels: [DetailTableViewCellModel]!

    override func setUp() {
        historicPricesInteractor = HistoricalPriceInteractor(withDisplayLayer: self, coinSource: MockCoinWatcher())
        testExpectation = XCTestExpectation(description: "test expectation")
        tableModels = nil
    }

    func testCoinSourceAssignment() {
        XCTAssertNotNil(historicPricesInteractor.coinSource)
    }
    
    func testCoinSourceDelegateAssignment() {
        
        // If view will appear is called, the coin source delegate should be assigned
        historicPricesInteractor.viewWillAppear()
        XCTAssertNotNil(historicPricesInteractor.coinSource.delegate)
        
        // If view will disappear is called, the coin source delegate should be unassigned
        historicPricesInteractor.viewWillDisappear()
        XCTAssertNil(historicPricesInteractor.coinSource.delegate)
    }
    
    func testHistoricPriceFetch() {
        let currencyTypes = [CurrencyType.eur, CurrencyType.usd, CurrencyType.gbp]
        historicPricesInteractor.viewWillAppear()
        historicPricesInteractor.fetchHistoricPrices(from: Date(), to: Date(), inCurrencies: currencyTypes)
        wait(for: [testExpectation], timeout: 5.0)
        XCTAssertEqual(tableModels.count, currencyTypes.count)
    }
}

extension HistoricPricesInteractorTests: HistoricPricingDisplay {
    
    func shouldDisplay(tableData: [DetailTableViewCellModel]) {
        tableModels = tableData
        testExpectation.fulfill()
    }
}
