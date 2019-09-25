//
//  AuthorizerProtocol.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 16/09/2019.
//

import Foundation

public protocol MiddlewareProtocol {

    func apply(
        endpoint: EndpointProtocol,
        request: URLRequest) -> URLRequest
}
