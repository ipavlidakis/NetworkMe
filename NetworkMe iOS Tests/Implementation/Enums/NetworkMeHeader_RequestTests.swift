//
//  NetworkMeHeader_RequestTests.swift
//  NetworkMe iOS Tests
//
//  Created by Ilias Pavlidakis on 03/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import XCTest
#if os(iOS)
@testable import NetworkMe_iOS
#elseif os(tvOS)
@testable import NetworkMe_tvOS
#else
@testable import NetworkMe_macOS
#endif

final class NetworkHeader_RequestTests: XCTestCase {

    // MARK: - CacheControl

    func test_cacheControl_keyPairsAreAsExpected() {

        let expected = [
            "no-cache",
            "no-store",
            "max-age=10.0",
            "max-stale=100.0",
            "min-fresh=1000.0",
            "no-transform",
            "only-if-cached",
            "cache-extension",
        ].map { NetworkMe.TransformableKeyValuePair<String, String>("Cache-Control",$0) }

        let allCases: [NetworkMe.Header.Request.CacheControl] = [
            .noCache,
            .noStore,
            .maxAge(10),
            .maxStale(100),
            .minFresh(1000),
            .noTransform,
            .onlyIfCached,
            .cacheExtension
        ]

        guard
            expected.count == allCases.count
        else {
            return XCTFail("Not tested CacheControl cases detected. Tests require update")
        }

        allCases.enumerated().forEach {

            XCTAssertEqual(
                NetworkMe.Header.Request.cacheControl($0.element).keyPair,
                expected[$0.offset])
        }
    }

    // MARK: - Custom

    func test_custom_keyPairsAreAsExpected() {

        let expected = [
            NetworkMe.TransformableKeyValuePair<String, String>("key1","value1"),
            NetworkMe.TransformableKeyValuePair<String, String>("key2","value2"),
        ]

        XCTAssertEqual(
            NetworkMe.Header.Request.custom(key: "key1", value: "value1").keyPair,
            expected.first!)
        XCTAssertEqual(
            NetworkMe.Header.Request.custom(key: "key2", value: "value2").keyPair,
            expected.last!)
    }

    // MARK: - Authorization

    func test_authorization_keyPairsAreAsExpected() {

        let expected = [
            "dGVzdFVzZXI6UGFzc3cwcmQ=",
            "Bearer testTo232dsaken",
            ].map { NetworkMe.TransformableKeyValuePair<String, String>("Authorization",$0) }

        let allCases: [NetworkMe.Header.Request.Authorization] = [
            .basic(username: "testUser", password: "Passw0rd"),
            .bearer(token: "testTo232dsaken")
        ]

        guard
            expected.count == allCases.count
        else {
            return XCTFail("Not tested Authorization cases detected. Tests require update")
        }

        allCases.enumerated().forEach {

            XCTAssertEqual(
                NetworkMe.Header.Request.authorization($0.element).keyPair,
                expected[$0.offset])
        }
    }

    // MARK: - ContentType

    func test_contentType_keyPairsAreAsExpected() {

        let expected = [
            "application/x-www-form-urlencoded",
            "application/xml",
            "application/xml-dtd",
            "application/xop+xml",
            "application/zip",
            "application/gzip",
            "application/graphql",
            "application/postscript",
            "application/rdf+xml",
            "application/rss+xml",
            "application/soap+xml",
            "application/fornt-woff",
            "application/x-yaml",
            "application/xhtml+xml",
            "application/atom+xml",
            "application/ecmascript",
            "application/json",
            "application/javascript",
            "application/octet-stream",
            "application/ogg",
            "application/pdf"
        ].map { NetworkMe.TransformableKeyValuePair<String, String>("Content-Type", $0) }

        guard
            expected.count == NetworkMe.Header.Request.ContentType.allCases.count
        else {
            return XCTFail("Not tested ContentType cases detected. Tests require update")
        }

        NetworkMe.Header.Request.ContentType.allCases.enumerated().forEach {

            XCTAssertEqual(
                NetworkMe.Header.Request.contentType($0.element).keyPair,
                expected[$0.offset])
        }
    }
}
