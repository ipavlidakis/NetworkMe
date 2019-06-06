//
//  NetworkMeFileRetriever_Tests.swift
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

final class NetworkMeFileRetriever_Tests: XCTestCase {

    private lazy var rawData: [String: String]! = ["key": "value"]
    private lazy var url: URL! = URL(fileURLWithPath: "tmp/\(UUID().uuidString)")

    override func setUp() {

        super.setUp()

        let data = try! JSONEncoder().encode(rawData)
        try! data.write(to: url)
    }

    override func tearDown() {

        try? FileManager().removeItem(at: url)

        rawData = nil
        url = nil

        super.tearDown()
    }
}

extension NetworkMeFileRetriever_Tests {

    // MARK: - fetch

    func test_fetch_correctDataReturned() {

        let fileRetriever = NetworkMe.FileRetriever()

        let fetchedData = fileRetriever.fetchData(from: url)!
        let decodedData = try? JSONDecoder().decode([String: String].self, from: fetchedData)

        XCTAssertEqual(decodedData, rawData)
    }
}
