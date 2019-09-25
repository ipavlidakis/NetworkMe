//
//  NetworkMeStub+Authorizer.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 17/09/2019.
//

import Foundation
import NetworkMe

extension NetworkMe.Stub {

    final class Middleware {

        private(set) var applyWasCalled: (endpoint: EndpointProtocol, request: URLRequest)?
    }
}

extension NetworkMe.Stub.Middleware: MiddlewareProtocol {

    func apply(
        endpoint: EndpointProtocol,
        request: URLRequest) -> URLRequest {

        applyWasCalled = (endpoint, request)

        return request
    }
}
