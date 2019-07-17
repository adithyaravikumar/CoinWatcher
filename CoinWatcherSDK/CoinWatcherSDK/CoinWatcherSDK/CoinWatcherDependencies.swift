//
//  CoinWatcherDependencies.swift
//  CoinWatcherSDK
//
//  Created by Adi Ravikumar on 7/16/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

/// Everything that the CoinWatcher needs should be defined in this protocol
public protocol CoinWatcherDependencies {
    
    var refreshInterval: TimeInterval { get }
    
    var urlSession: URLSession { get }
    
    var currencyType: CurrencyType { get }
    
    var baseUrl: String { get }
    
    var networkCoordinator: NetworkCoordinating { get }
}

/// Default coin watcher dependencies
public class DefaultCoinWatcherDependencies: CoinWatcherDependencies {
    
    enum Constants {
        static let defaultBaseUrl = "https://api.coindesk.com/v1/bpi/"
        static let defaultRefreshInterval = 60.0
        static let defaultCurrencyType = CurrencyType.eur
    }
    
    public var refreshInterval: TimeInterval
    public let urlSession: URLSession
    public let currencyType: CurrencyType
    public let baseUrl: String
    public let networkCoordinator: NetworkCoordinating
    
    public init() {
        refreshInterval = Constants.defaultRefreshInterval
        urlSession = URLSession.init(configuration: .default)
        currencyType = Constants.defaultCurrencyType
        baseUrl = Constants.defaultBaseUrl
        networkCoordinator = NetworkCoordinator(with: urlSession, baseURL: baseUrl)
    }
}
