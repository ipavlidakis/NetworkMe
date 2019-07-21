//
//  NetworkMeRouting.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 02/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public protocol NetworkMeRouting {

    func request(
        endpoint: NetworkMeEndpointProtocol)

    func request<ResultItem: Decodable>(
        endpoint: NetworkMeEndpointProtocol,
        completion: @escaping (Result<ResultItem, NetworkMe.Router.NetworkError>, [NetworkMe.Header.Response]?) -> Void)
}
