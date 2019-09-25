//
//  NetworkMe+BasicAuthorizer.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 17/09/2019.
//

import Foundation

extension NetworkMe {

    public struct BearerAuthorizer {

        let accessTokenProvider: () -> String

        public init(accessTokenProvider: @escaping () -> String) {

            self.accessTokenProvider = accessTokenProvider
        }
    }
}

extension NetworkMe.BearerAuthorizer: MiddlewareProtocol {

    public func apply(
        endpoint: EndpointProtocol,
        request: URLRequest) -> URLRequest {

        var mutableRequest = request
        let authorizationHeader = NetworkMe.Header.Request.authorization(
            NetworkMe.Header.Request.Authorization.bearer(
                token: accessTokenProvider()))

        mutableRequest.allHTTPHeaderFields = {

            let keyPair = authorizationHeader.keyPair
            guard let headers = mutableRequest.allHTTPHeaderFields else {
                return [authorizationHeader.keyPair.key: authorizationHeader.keyPair.value]
            }

            return headers.merging([keyPair.key: keyPair.value], uniquingKeysWith: { $1 })
        }()

        return mutableRequest
    }
}
