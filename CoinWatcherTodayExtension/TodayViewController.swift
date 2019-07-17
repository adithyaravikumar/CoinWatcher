//
//  TodayViewController.swift
//  CoinWatcherTodayExtension
//
//  Created by Adi Ravikumar on 7/14/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import UIKit
import NotificationCenter
import CoinWatcherSDK

protocol TodayViewDisplay: AnyObject {
    func displayCurrentPriceChange(with coinData: CurrentCoinData)
}

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyTypeLabel: UILabel!
    
    var interactor: TodayInteraction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor = TodayInteractor(withDisplayLayer: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        interactor?.viewWillDisappear()
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
}

extension TodayViewController: TodayViewDisplay {
    
    func displayCurrentPriceChange(with coinData: CurrentCoinData) {
        priceLabel.text = coinData.bpi.bitcoinEUPricing.rate
    }
}
