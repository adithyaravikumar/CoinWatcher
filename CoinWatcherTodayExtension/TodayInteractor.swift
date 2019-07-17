//
//  TodayInteractor.swift
//  CoinWatcherTodayExtension
//
//  Created by Adi Ravikumar on 7/15/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import CoinWatcherSDK

protocol TodayInteraction: AnyObject {
    var coinSource: CoinWatching { get }
    var displayLayer: TodayViewDisplay? { get }
    func viewWillAppear()
    func viewWillDisappear()
}

final class TodayInteractor: TodayInteraction {
    let coinSource: CoinWatching
    weak var displayLayer: TodayViewDisplay?
    
    init(withDisplayLayer displayLayer: TodayViewDisplay) {
        self.displayLayer = displayLayer
        let coinWatcherDependencies = DefaultCoinWatcherDependencies()
        coinSource = CoinWatcher(with: coinWatcherDependencies)
    }
    
    func viewWillAppear() {
        coinSource.delegate = self
        coinSource.startWatching()
    }
    
    func viewWillDisappear() {
        coinSource.delegate = nil
        coinSource.stopWatching()
    }
}

extension TodayInteractor: CoinWatchingDelegate {
    func didUpdate(coinData: CurrentCoinData) {
        DispatchQueue.main.async { [weak self] in
            self?.displayLayer?.displayCurrentPriceChange(with: coinData)
        }
    }
}
