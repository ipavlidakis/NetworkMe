//
//  NetworkMeStub+Authorizer.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 17/09/2019.
//

import Foundation
import NetworkMe

extension NetworkMe.Stub {

    final class Authorizer {

        private(set) var authorizeWasCalled: (endpoint: EndpointProtocol, request: URLRequest)?
    }
}

extension NetworkMe.Stub.Authorizer: AuthorizerProtocol {

    func authorize(
        endpoint: EndpointProtocol,
        request: URLRequest) -> URLRequest {

        authorizeWasCalled = (endpoint, request)

        return request
    }
}
