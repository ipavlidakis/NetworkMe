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
import NetworkMe_iOS
#elseif os(tvOS)
import NetworkMe_tvOS
#else
import NetworkMe_macOS
#endif

final class NetworMeMethod_Tests: XCTestCase {

    func test_rawValuesAreAsExpected() {

        XCTAssertEqual(NetworkMe.Method.get.rawValue, "get")
        XCTAssertEqual(NetworkMe.Method.post.rawValue, "post")
        XCTAssertEqual(NetworkMe.Method.put.rawValue, "put")
        XCTAssertEqual(NetworkMe.Method.delete.rawValue, "delete")
    }
}

