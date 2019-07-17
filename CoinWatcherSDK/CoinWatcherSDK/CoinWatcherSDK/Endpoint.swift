//
//  Endpoint.swift
//  CoinWatcherSDK
//
//  Created by Adi Ravikumar on 7/15/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

public enum Endpoint {
    private static let currentPriceEndpoint = "currentprice.json"
    private static let historicPriceEndpoint = "historical/close.json"
    
    case currentPrice
    case historicPrice(currencyType: CurrencyType, startDate: String, endDate: String)
    
    var path: String {
        switch self {
        case .currentPrice:
            return Endpoint.currentPriceEndpoint
        case .historicPrice(let currencyType, let startDate, let endDate):
            return "\(Endpoint.historicPriceEndpoint)?currency=\(currencyType.rawValue)&start=\(startDate)&end=\(endDate)"
        }
    }
}
