//
//  StartupConfiguration.swift
//  CoinWatcher
//
//  Created by Adi Ravikumar on 7/14/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import UIKit
import CoinWatcherSDK

/// Defines everything the app needs to be launched successfully
protocol StartupConfiguration {
    var storyboard: UIStoryboard { get }
    var coinSource: CoinWatching { get }
}

/// This is the default startup configuration for the app.
final class AppStartupConfiguration: StartupConfiguration {
    
    private enum Constants {
        static let mainStoryboardName = "Main"
    }
    
    static let defaultSetup = AppStartupConfiguration(withStoryboardName: Constants.mainStoryboardName)
    
    let storyboard: UIStoryboard
    let coinSource: CoinWatching
    
    required init(withStoryboardName storyboardName: String, coinSource: CoinWatching = CoinWatcher()) {
        storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        self.coinSource = coinSource
    }
}
