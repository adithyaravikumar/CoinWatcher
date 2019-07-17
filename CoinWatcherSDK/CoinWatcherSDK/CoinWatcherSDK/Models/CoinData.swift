//
//  CoinData.swift
//  CoinWatcherSDK
//
//  Created by Adi Ravikumar on 7/15/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

public struct BitcoinPriceIndex: Decodable {
    enum CodingKeys: String, CodingKey {
        case bitcoinUSPricing = "USD"
        case bitcoinUKPricing = "GBP"
        case bitcoinEUPricing = "EUR"
    }
    
    public let bitcoinUSPricing: CoinPricing
    public let bitcoinUKPricing: CoinPricing
    public let bitcoinEUPricing: CoinPricing
}

public struct CurrentCoinData: Decodable {
    public let bpi: BitcoinPriceIndex
}

public struct HistoricCoinData: Decodable {
    let bpi: [String: Double]
    
    public var pricesByDate: [DatedCoinPricing] {
        var values = [DatedCoinPricing]()
        bpi.keys.forEach { (key) in
            let priceOnDate = bpi[key] ?? 0.0
            values.append(DatedCoinPricing(date: key, price: priceOnDate))
        }
        return values
    }
}
