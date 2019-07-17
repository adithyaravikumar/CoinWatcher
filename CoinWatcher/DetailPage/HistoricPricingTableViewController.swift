//
//  HistoricPricingTableViewController.swift
//  CoinWatcher
//
//  Created by Adi Ravikumar on 7/15/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import UIKit
import CoinWatcherSDK

/// Interactor -> View communication
protocol HistoricPricingDisplay: AnyObject {
    func shouldDisplay(tableData: [DetailTableViewCellModel])
}

class HistoricPricingTableViewController: UITableViewController {
    
    private enum Constants {
        static let defaultDateFormat = "yyyy-MM-dd"
        static let tableCellReuseIdentifier = "historicPriceCell"
        static let cellHeight: CGFloat = 100
    }
    
    public var pricingDate: String?
    private var tableData = [DetailTableViewCellModel]()
    private var interactor: HistoricalPriceInteraction?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        interactor = HistoricalPriceInteractor(withDisplayLayer: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.viewWillAppear()
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.defaultDateFormat
        
        guard let dateValue = pricingDate, let date = formatter.date(from: dateValue) else {
            return
        }
        let currencies = [CurrencyType.eur, CurrencyType.usd, CurrencyType.gbp]
        interactor?.fetchHistoricPrices(from: date, to: date, inCurrencies: currencies)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        interactor?.viewWillDisappear()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableCellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = "\(tableData[indexPath.row].historicCoinData.pricesByDate.first?.price ?? 0)"
        cell.detailTextLabel?.text = tableData[indexPath.row].currencyType.rawValue
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}

// MARK: - HistoricPricingDisplay
extension HistoricPricingTableViewController: HistoricPricingDisplay {
    
    func shouldDisplay(tableData: [DetailTableViewCellModel]) {
        self.tableData = tableData
        tableView.reloadSections(IndexSet(integersIn: 0...0), with: .automatic)
    }
}
