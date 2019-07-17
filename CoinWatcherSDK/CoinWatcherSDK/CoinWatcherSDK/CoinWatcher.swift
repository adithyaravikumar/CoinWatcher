//
//  CoinWatcher.swift
//  CoinWatcherSDK
//
//  Created by Adi Ravikumar on 7/15/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

public enum CoinWatcherError: Error {
    case apiFailure
    
    var localizedDescription: String {
        return "Error fetching prices from server"
    }
}

public protocol CoinWatching: AnyObject {
    var delegate: CoinWatchingDelegate? { get set }
    func startWatching()
    func stopWatching()
    func fetchCurrentPrice()
    func fetchHistoricPrices(from startDate: Date, to endDate: Date, inCurrency currencyType: CurrencyType)
}

public protocol CoinWatchingDelegate: AnyObject {
    func didUpdate(coinData: CurrentCoinData)
    func didFetch(historicData: HistoricCoinData, inCurrency currencyType: CurrencyType)
    func didFail(with error: Error)
}

// MARK: - Default implementation of CoinWatchingDelegate
public extension CoinWatchingDelegate {
    
    func didUpdate(coinData: CurrentCoinData) {
        // no-op
    }
    
    func didFetch(historicData: HistoricCoinData, inCurrency currencyType: CurrencyType) {
        // no-op
    }
    
    func didFail(with error: Error) {
        // no-op
    }
}

public final class CoinWatcher: CoinWatching {
    
    private enum Constants {
        static let defaultDateFormat = "yyyy-MM-dd"
    }
    
    // Public
    public weak var delegate: CoinWatchingDelegate?
    
    // Private
    private(set) var timer: Timer?
    private let dateFormatter: DateFormatter
    private let decoder = JSONDecoder()
    private let dependencies: CoinWatcherDependencies
    
    public init(with dependencies: CoinWatcherDependencies = DefaultCoinWatcherDependencies()) {
        
        // Setup private values
        self.dependencies = dependencies
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.defaultDateFormat
    }
    
    public func startWatching() {
        setupCoinRefreshTimer()
    }
    
    public func stopWatching() {
        clearCoinRefreshTimer()
    }
    
    public func fetchCurrentPrice() {
        refreshCurrentCoinPrice()
    }
    
    public func fetchHistoricPrices(from startDate: Date, to endDate: Date, inCurrency currencyType: CurrencyType) {
        retrieveCoinPrices(from: startDate, to: endDate, inCurrency: currencyType)
    }
}

// MARK: - Private
private extension CoinWatcher {
    func setupCoinRefreshTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: dependencies.refreshInterval, repeats: true, block: { [weak self] (timer) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.refreshCurrentCoinPrice()
        })
        timer?.fire()
    }
    
    func clearCoinRefreshTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func refreshCurrentCoinPrice() {
        dependencies.networkCoordinator.getData(for: .currentPrice) { [weak self] (data, response, error) in
            do {
                guard let responseData = data, let currentCoinData = try self?.decoder.decode(CurrentCoinData.self, from: responseData) else {
                    self?.handle(error: CoinWatcherError.apiFailure)
                    return
                }
                self?.delegate?.didUpdate(coinData: currentCoinData)
            } catch {
                self?.handle(error: error)
            }
        }
    }
    
    func retrieveCoinPrices(from startDate: Date, to endDate: Date, inCurrency currencyType: CurrencyType) {
        let startdateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        dependencies.networkCoordinator.getData(for: .historicPrice(currencyType: currencyType, startDate: startdateString, endDate: endDateString), completionHandler: { [weak self] (data, response, error) in
            do {
                guard let responseData = data, let historicData = try self?.decoder.decode(HistoricCoinData.self, from: responseData) else {
                    self?.handle(error: CoinWatcherError.apiFailure)
                    return
                }
                self?.delegate?.didFetch(historicData: historicData, inCurrency: currencyType)
            } catch {
                self?.handle(error: error)
            }
        })
    }
    
    func handle(error: Error) {
        delegate?.didFail(with: error)
        print("An error occurred while trying to decode current bitcoin price data from server. Error: \(error.localizedDescription)")
    }
}
