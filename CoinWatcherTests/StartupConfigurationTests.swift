//
//  StartupConfigurationTests.swift
//  CoinWatcherTests
//
//  Created by Adi Ravikumar on 7/16/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import XCTest
@testable import CoinWatcher

class StartupConfigurationTests: XCTestCase {

    func testAppStartupConfigurationAssignments() {
        let appStartupConfiguration = AppStartupConfiguration(withStoryboardName: "Main")
        XCTAssertNotNil(appStartupConfiguration.storyboard)
        XCTAssertNotNil(appStartupConfiguration.coinSource)
    }
}
