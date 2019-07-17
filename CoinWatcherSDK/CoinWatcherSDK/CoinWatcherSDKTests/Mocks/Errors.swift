//
//  Errors.swift
//  CoinWatcherSDKTests
//
//  Created by Adi Ravikumar on 7/16/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import Foundation

enum TestingError: Error {
    case sampleError
    
    var errorDescription: String? {
        return "test"
    }
}
