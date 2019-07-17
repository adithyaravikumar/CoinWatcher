//
//  NetworkCoordinator.swift
//  CoinWatcher
//
//  Created by Adi Ravikumar on 7/14/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import Foundation

public protocol NetworkCoordinating {
    var urlSession: URLSession { get }
    var baseURL: String { get }
    func getData(for endpoint: Endpoint, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

final class NetworkCoordinator: NetworkCoordinating {
    
    let baseURL: String
    let urlSession: URLSession
    
    init(with urlSession: URLSession, baseURL: String) {
        self.urlSession = urlSession
        self.baseURL = baseURL
    }
    
    func getData(for endpoint: Endpoint, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let baseLink = URL(string: baseURL), let requestUrl = URL(string: endpoint.path, relativeTo: baseLink) else {
            return
        }
        urlSession.dataTask(with: requestUrl) { [weak self] (data, response, error) in
            self?.performGenericErrorHandling(for: error)
            completionHandler(data, response, error)
        }.resume()
    }
}

private extension NetworkCoordinator {
    func performGenericErrorHandling(for error: Error?) {
        guard let responseError = error else {
            return
        }
        print("Something went wrong while executing the networking request: Error: \(responseError.localizedDescription)")
    }
}
