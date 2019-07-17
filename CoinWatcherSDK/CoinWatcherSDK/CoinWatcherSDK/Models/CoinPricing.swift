//
//  CoinPricing.swift
//  CoinWatcherSDK
//
//  Created by Adi Ravikumar on 7/15/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

public enum CurrencyType: String {
    case usd = "USD"
    case gbp = "GBP"
    case eur = "EUR"
}

public struct CoinPricing: Decodable {
    public let code: String
    public let rate: String
    public let description: String
}

public struct DatedCoinPricing {
    public let date: String
    public let price: Double
}
