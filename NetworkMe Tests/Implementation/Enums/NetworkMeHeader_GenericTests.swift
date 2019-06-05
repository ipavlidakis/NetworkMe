//
//  NetworkMeHeader_GenericTests.swift
//  NetworkMe iOS Tests
//
//  Created by Ilias Pavlidakis on 03/06/2019.
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

final class NetworkMeHeader_GenericTests: XCTestCase {

    // MARK: - Connection

    func test_connection_keyPairsAreAsExpected() {

        let expected = [
            "keep-alive",
            "close"
        ].map { NetworkMe.TransformableKeyValuePair<String, String>("Connection", $0) }

        guard
            expected.count == NetworkMe.Header.Generic.Connection.allCases.count
        else {
            return XCTFail("Not tested Connection cases detected. Tests require update")
        }

        NetworkMe.Header.Generic.Connection.allCases.enumerated().forEach {

            XCTAssertEqual(
                NetworkMe.Header.Generic.connection($0.element).keyPair,
                expected[$0.offset])
        }
    }

    // MARK: - Date

    func test_date_rawValueAreAsExpected() {

        let stubDateProvider = NetworkMe.Stub.DateProvider()
        stubDateProvider.stubLocalizedStringResult = "test"

        let result = NetworkMe.Header.Generic.date(stubDateProvider).keyPair

        XCTAssertEqual(result.key, "Date")
        XCTAssertEqual(result.value, "test")
        XCTAssertEqual(
            stubDateProvider.localizedStringWasCalled?.date,
            Date(timeIntervalSince1970: 0))
    }
}
