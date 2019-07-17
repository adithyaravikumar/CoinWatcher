//
//  MockAppConfiguration.swift
//  CoinWatcherTests
//
//  Created by Adi Ravikumar on 7/16/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import UIKit
import CoinWatcherSDK
@testable import CoinWatcher

class MockAppConfiguration: StartupConfiguration {
    let coinSource: CoinWatching = MockCoinWatcher()
    let storyboard = UIStoryboard(name: "", bundle: nil)
}
