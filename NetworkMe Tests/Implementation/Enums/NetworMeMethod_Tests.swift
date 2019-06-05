//
//  NetworMeMethod_Tests.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 02/06/2019.
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

final class NetworMeMethod_Tests: XCTestCase {

    func test_rawValuesAreAsExpected() {

        XCTAssertEqual(NetworkMe.Method.get.rawValue, "get")
        XCTAssertEqual(NetworkMe.Method.post.rawValue, "post")
        XCTAssertEqual(NetworkMe.Method.put.rawValue, "put")
        XCTAssertEqual(NetworkMe.Method.delete.rawValue, "delete")
    }
}
