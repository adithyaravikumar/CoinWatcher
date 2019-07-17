//
//  MockNetworkCoordinator.swift
//  CoinWatcherSDKTests
//
//  Created by Adi Ravikumar on 7/16/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import CoinWatcherSDK

class MockNetworkCoordinator: NetworkCoordinating {
    
    let urlSession: URLSession
    let baseURL: String
    
    required init(urlSession: URLSession, baseURL: String) {
        self.urlSession = urlSession
        self.baseURL = baseURL
    }
    
    func getData(for endpoint: Endpoint, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) { }
}
