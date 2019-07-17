//
//  MockCoinWatcherDependencies.swift
//  CoinWatcherSDKTests
//
//  Created by Adi Ravikumar on 7/16/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import CoinWatcherSDK

struct MockCoinWatcherDependencies: CoinWatcherDependencies {
    
    let refreshInterval: TimeInterval
    let urlSession: URLSession
    let currencyType: CurrencyType
    let baseUrl: String
    let networkCoordinator: NetworkCoordinating
    
    init() {
        refreshInterval = 2.0
        urlSession = URLSession.init()
        currencyType = CurrencyType.usd
        baseUrl = ""
        networkCoordinator = MockNetworkCoordinator(urlSession: urlSession, baseURL: baseUrl)
    }
}
