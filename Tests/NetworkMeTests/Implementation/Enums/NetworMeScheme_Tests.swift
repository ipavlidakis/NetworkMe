//
//  NetworMeScheme_Tests.swift
//  NetworkMe iOS Tests
//
//  Created by Ilias Pavlidakis on 02/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import XCTest
import NetworkMe

final class NetworMeScheme_Tests: XCTestCase {

    func test_rawValuesAreAsExpected() {

        XCTAssertEqual(NetworkMe.Scheme.http.rawValue, "http")
        XCTAssertEqual(NetworkMe.Scheme.https.rawValue, "https")
    }
}
