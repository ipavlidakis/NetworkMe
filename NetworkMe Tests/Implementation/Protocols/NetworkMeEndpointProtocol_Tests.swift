//
//  NetworkMeEndpointProtocol_Tests.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 06/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import XCTest
#if os(iOS)
#if canImport(NetworkMe_iOS)
@testable import NetworkMe_iOS
#else
@testable import NetworkMe
#endif
#elseif os(tvOS)
@testable import NetworkMe_tvOS
#elseif os(macOS)
@testable import NetworkMe_macOS
#endif

final class NetworkMeEndpointProtocol_Tests: XCTestCase {

    func test_endpointHasExpectedDefaultValues() {

        enum Endpoint: NetworkMeEndpointProtocol {
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
        XCTAssert(Endpoint.test.headers.isEmpty)
    }
}
