//
//  NetworkMeEndpointProtocol_Tests.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 06/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import XCTest
import NetworkMe

final class NetworkMeEndpointProtocol_Tests: XCTestCase {

    func test_endpointHasExpectedDefaultValues() {

        enum Endpoint: EndpointProtocol {
            case test
            var url: URL { return URL(string: "test.com")! }
        }

        XCTAssertEqual(Endpoint.test.taskType, .data)
        XCTAssertEqual(Endpoint.test.url, URL(string: "test.com")!)
        XCTAssertNil(Endpoint.test.body)
        XCTAssertNil(Endpoint.test.queryItems)
        XCTAssertEqual(Endpoint.test.scheme, .https)
        XCTAssertEqual(Endpoint.test.method, .get)
        XCTAssertEqual(Endpoint.test.cachePolicy, .useProtocolCachePolicy)
        XCTAssertEqual(Endpoint.test.timeoutInterval, 30)
        XCTAssert(Endpoint.test.decoder is JSONDecoder)
        XCTAssert(Endpoint.test.requestHeaders.isEmpty)
    }
}
