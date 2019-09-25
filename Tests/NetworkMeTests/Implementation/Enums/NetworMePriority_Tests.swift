//
//  NetworMePriority_Tests.swift
//  NetworkMeTests
//
//  Created by Ilias Pavlidakis on 25/09/2019.
//

import Foundation
import XCTest

@testable import NetworkMe

final class NetworMePriority_Tests: XCTestCase {

    func test_qualityOfServiceAreAsExpected() {

        XCTAssertEqual(NetworkMe.Priority.high.qualityOfService, .userInitiated)
        XCTAssertEqual(NetworkMe.Priority.normal.qualityOfService, .default)
        XCTAssertEqual(NetworkMe.Priority.low.qualityOfService, .background)
    }

    func test_maxConcurrentOperationsAreAsExpected() {

        XCTAssertEqual(NetworkMe.Priority.high.maxConcurrentOperations, 3)
        XCTAssertEqual(NetworkMe.Priority.normal.maxConcurrentOperations, 5)
        XCTAssertEqual(NetworkMe.Priority.low.maxConcurrentOperations, 10)
    }
}

