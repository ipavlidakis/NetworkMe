//
//  NetworkMeAuthorizer_Tests.swift
//  NetworkMeTests
//
//  Created by Ilias Pavlidakis on 17/09/2019.
//

import XCTest
import NetworkMe

final class NetworkMeAuthorizer_Tests: XCTestCase {

    // MARK: - authorize

    func test_authorize_accessTokenProviderWasCalled() {

        var accessTokenProviderWasCalled = false
        let authorizer = NetworkMe.BearerAuthorizer {
            accessTokenProviderWasCalled = true
            return ""
        }

        _ = authorizer.apply(endpoint: NetworkMe.Stub.Endpoint(), request: URLRequest(url: URL(string: "test.com")!))

        XCTAssert(accessTokenProviderWasCalled)
    }

    func test_authorize_returnsCorrectlyConfiguredRequest() {

        let authorizer = NetworkMe.BearerAuthorizer { "token" }

        let request = authorizer.apply(endpoint: NetworkMe.Stub.Endpoint(), request: URLRequest(url: URL(string: "test.com")!))

        XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bearer token")
    }
}
