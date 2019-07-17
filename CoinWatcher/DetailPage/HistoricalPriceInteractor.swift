//
//  HistoricalPriceInteractor.swift
//  CoinWatcher
//
//  Created by Adi Ravikumar on 7/15/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import CoinWatcherSDK

/// This is the protocol that the interactor will conform to. This logic will be triggered by the view layer.
protocol HistoricalPriceInteraction: AnyObject {
    var coinSource: CoinWatching { get }
    func viewWillAppear()
    func viewWillDisappear()
    func fetchHistoricPrices(from startDate: Date, to endDate: Date, inCurrencies currencyTypes: [CurrencyType])
}

/// This is the data each table view cell needs for its display
struct DetailTableViewCellModel {
    let historicCoinData: HistoricCoinData
    let currencyType: CurrencyType
}

// MARK: - HistoricalPriceInteraction
class HistoricalPriceInteractor: HistoricalPriceInteraction {
    
    let coinSource: CoinWatching
    private weak var displayLayer: HistoricPricingDisplay?
    private var tableDetails = [DetailTableViewCellModel]()
    private var itemCount = 0
    
    init(withDisplayLayer displayLayer: HistoricPricingDisplay, coinSource: CoinWatching = AppStartupConfiguration.defaultSetup.coinSource) {
        self.displayLayer = displayLayer
        self.coinSource = coinSource
    }
    
    func viewWillAppear() {
        coinSource.delegate = self
    }
    
    func viewWillDisappear() {
        coinSource.delegate = nil
    }
    
    func fetchHistoricPrices(from startDate: Date, to endDate: Date, inCurrencies currencyTypes: [CurrencyType]) {
        itemCount = currencyTypes.count
        for currencyType in currencyTypes {
            coinSource.fetchHistoricPrices(from: startDate, to: endDate, inCurrency: currencyType)
        }
    }
}

// MARK: - CoinWatchingDelegate
extension HistoricalPriceInteractor: CoinWatchingDelegate {
    
    func didFetch(historicData: HistoricCoinData, inCurrency currencyType: CurrencyType) {
        tableDetails.append(DetailTableViewCellModel(historicCoinData: historicData, currencyType: currencyType))
        guard tableDetails.count == itemCount else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.displayLayer?.shouldDisplay(tableData: strongSelf.tableDetails)
        }
    }
}
