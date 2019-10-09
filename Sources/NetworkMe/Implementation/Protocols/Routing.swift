//
//  Routing.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 02/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public protocol Routing {

    func add(middleware: MiddlewareProtocol)

    func cancelRequests(with priorities: [NetworkMe.Priority])

    func cancelRequest(for endpoint: EndpointProtocol)

    func request(
        endpoint: EndpointProtocol)

    func request<ResultItem: Decodable>(
        endpoint: EndpointProtocol,
        completion: @escaping (Result<ResultItem, NetworkMe.Router.NetworkError>, [NetworkMe.Header.Response]?) -> Void)
}
