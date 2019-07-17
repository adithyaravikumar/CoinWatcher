//
//  HomeViewController.swift
//  CoinWatcher
//
//  Created by Adi Ravikumar on 7/14/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import UIKit
import CoinWatcherSDK

public protocol HomeDisplay: AnyObject {
    func displayCurrentPriceChange(with coinData: CurrentCoinData)
    func displayHistoricPriceChange(for historicData: HistoricCoinData)
    func displayGenericErrorAlert()
}

class HomeViewController: UIViewController {
    
    /// Constants specific to this class reside here.
    /// Why is this an enum? This is just to avoid anyone from instantiating this.
    private enum Constants {
        
        // Controllers
        static let historicPricingTableViewController = "HistoricPricingTableViewController"
        
        // Table View Constants
        static let weekdayHeaderTitle = "Price from the last 2 weeks"
        static let weekdayCellReuseIdentifier = "weekdayPriceCell"
        static let weekdayCellHeight: CGFloat = 100.0
        static let weekdayTitleHeight: CGFloat = 100.0
        
        // Alert Constants
        static let alertTitle = "Oops!"
        static let alertMessage = "Something went wrong! Please check your internet connection or try again later."
        static let alertButtonText = "OK"
    }
    
    // Outlets
    @IBOutlet weak var weekdayTableView: UITableView!
    @IBOutlet weak var refreshNowButton: UIButton!
    @IBOutlet weak var currentPriceLabel: UILabel!
    
    // Interactor
    var interactor: HomeInteraction?
    
    // Table View Data
    var datedCoinPrices: [DatedCoinPricing]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataLinkage()
        fetchBiweeklyData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        interactor?.viewWillDisappear()
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        interactor?.fetchLatestPrice()
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datedCoinPrices?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.weekdayCellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = datedCoinPrices?[indexPath.row].date
        cell.detailTextLabel?.text = "\(datedCoinPrices?[indexPath.row].price ?? 0)"
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 0 else {
            return nil
        }
        return Constants.weekdayHeaderTitle
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.weekdayTitleHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.weekdayCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = AppStartupConfiguration.defaultSetup.storyboard
        guard let dateAtIndex = datedCoinPrices?[indexPath.row].date, let controller = storyboard.instantiateViewController(withIdentifier: Constants.historicPricingTableViewController) as? HistoricPricingTableViewController else {
            return
        }
        controller.pricingDate = dateAtIndex
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - HomeViewDisplay
extension HomeViewController: HomeDisplay {
    func displayCurrentPriceChange(with coinData: CurrentCoinData) {
        let currentPriceInEuro = "\(CurrencyType.eur.rawValue) \(coinData.bpi.bitcoinEUPricing.rate)"
        currentPriceLabel.text = currentPriceInEuro
    }
    
    func displayHistoricPriceChange(for historicData: HistoricCoinData) {
        datedCoinPrices = historicData.pricesByDate
        weekdayTableView.reloadSections(IndexSet(integersIn: 0...0), with: .automatic)
    }
    
    func displayGenericErrorAlert() {
        let alertController = UIAlertController(title: Constants.alertTitle, message: Constants.alertMessage, preferredStyle: .actionSheet)
        let alertButton = UIAlertAction(title: Constants.alertButtonText, style: .cancel, handler: nil)
        alertController.addAction(alertButton)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Private
private extension HomeViewController {
    
    func setupDataLinkage() {
        weekdayTableView.dataSource = self
        weekdayTableView.delegate = self
        interactor = HomeInteractor(withDisplayLayer: self)
    }
    
    func fetchBiweeklyData() {
        let today = Date()
        guard let earlierDate = Calendar.current.date(byAdding: .day, value: -14, to: today) else {
            return
        }
        interactor?.fetchHistoricPrices(from: earlierDate, to: today, inCurrency: .eur)
    }
}
