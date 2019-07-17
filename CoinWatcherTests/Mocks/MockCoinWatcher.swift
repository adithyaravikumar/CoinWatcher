//
//  MockCoinWatcher.swift
//  CoinWatcherTests
//
//  Created by Adi Ravikumar on 7/16/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

@testable import CoinWatcherSDK

class MockCoinWatcher: CoinWatching {
    
    var delegate: CoinWatchingDelegate?
    
    private let currentCoinData: CurrentCoinData
    private let historicCoinData: HistoricCoinData
    
    init() {
        let testCoinPricing = CoinPricing(code: "test", rate: "test", description: "test")
        let bitCoinPriceIndex = BitcoinPriceIndex(bitcoinUSPricing: testCoinPricing, bitcoinUKPricing: testCoinPricing, bitcoinEUPricing: testCoinPricing)
        currentCoinData = CurrentCoinData(bpi: bitCoinPriceIndex)
        historicCoinData = HistoricCoinData(bpi: ["test": 20.0])
    }
    
    func startWatching() {
        delegate?.didUpdate(coinData: currentCoinData)
    }
    
    func stopWatching() {
        // no-op
    }
    
    func fetchCurrentPrice() {
        delegate?.didUpdate(coinData: currentCoinData)
    }
    
    func fetchHistoricPrices(from startDate: Date, to endDate: Date, inCurrency currencyType: CurrencyType) {
        delegate?.didFetch(historicData: historicCoinData, inCurrency: currencyType)
    }
}
