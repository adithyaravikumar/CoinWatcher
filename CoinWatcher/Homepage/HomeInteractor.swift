//
//  HomeInteractor.swift
//  CoinWatcher
//
//  Created by Adi Ravikumar on 7/14/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import CoinWatcherSDK

/// The Home interactor should conform to this protocol. This will be triggered by the view layer.
protocol HomeInteraction: AnyObject {
    var coinSource: CoinWatching { get }
    var displayLayer: HomeDisplay? { get }
    func viewWillAppear()
    func viewWillDisappear()
    func fetchLatestPrice()
    func fetchHistoricPrices(from startDate: Date, to endDate: Date, inCurrency currencyType: CurrencyType)
}

// MARK: - HomeInteraction
final class HomeInteractor: HomeInteraction {
    weak var displayLayer: HomeDisplay?
    let coinSource: CoinWatching
    
    init(withDisplayLayer displayLayer: HomeDisplay, coinSource: CoinWatching = AppStartupConfiguration.defaultSetup.coinSource) {
        self.displayLayer = displayLayer
        self.coinSource = coinSource
    }
    
    func viewWillAppear() {
        coinSource.delegate = self
        coinSource.startWatching()
    }
    
    func viewWillDisappear() {
        coinSource.delegate = nil
        coinSource.stopWatching()
    }
    
    func fetchLatestPrice() {
        coinSource.fetchCurrentPrice()
    }
    
    func fetchHistoricPrices(from startDate: Date, to endDate: Date, inCurrency currencyType: CurrencyType) {
        coinSource.fetchHistoricPrices(from: startDate, to: endDate, inCurrency: currencyType)
    }
}

// MARK: - CoinWatchingDelegate
extension HomeInteractor: CoinWatchingDelegate {
    func didUpdate(coinData: CurrentCoinData) {
        DispatchQueue.main.async { [weak self] in
            self?.displayLayer?.displayCurrentPriceChange(with: coinData)
        }
    }
    
    func didFail(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.displayLayer?.displayGenericErrorAlert()
        }
    }
    
    func didFetch(historicData: HistoricCoinData, inCurrency currencyType: CurrencyType) {
        DispatchQueue.main.async { [weak self] in
            self?.displayLayer?.displayHistoricPriceChange(for: historicData)
        }
    }
}
