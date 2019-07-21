//
//  NetworkHeader_ResponseTests.swift
//  NetworkMe iOS Tests
//
//  Created by Ilias Pavlidakis on 03/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import XCTest
@testable import NetworkMe

final class NetworkHeader_ResponseTests: XCTestCase {

    // MARK: - CacheControl

    func test_cacheControl_keyPairsAreAsExpected() {

        let expected = [
            "must-revalidate",
            "no-cache",
            "no-store",
            "no-transform",
            "public",
            "private",
            "proxy-revalidate",
            "max-age=10.0",
            "s-maxage=100.0",
        ].map { NetworkMe.TransformableKeyValuePair<String, String>("Cache-Control",$0) }

        let allCases: [NetworkMe.Header.Response.CacheControl] = [
            .mustRevalidate,
            .noCache,
            .noStore,
            .noTransform,
            .publicCache,
            .privateCache,
            .proxyRevalidate,
            .maxAge(10),
            .sMaxAge(100),
        ]

        guard
            expected.count == allCases.count
        else {
            return XCTFail("Not tested CacheControl cases detected. Tests require update")
        }

        allCases.enumerated().forEach {

            XCTAssertEqual(
                NetworkMe.Header.Response.cacheControl($0.element).keyPair,
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
            NetworkMe.Header.Response.custom(key: "key1", value: "value1").keyPair,
            expected.first!)
        XCTAssertEqual(
            NetworkMe.Header.Response.custom(key: "key2", value: "value2").keyPair,
            expected.last!)
    }

    // MARK: - Accept

    func test_accept_keyPairsAreAsExpected() {

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
            ].map { NetworkMe.TransformableKeyValuePair<String, String>("Accept", $0) }

        guard
            expected.count == NetworkMe.Header.Response.Accept.allCases.count
            else {
                return XCTFail("Not tested ContentType cases detected. Tests require update")
        }

        NetworkMe.Header.Response.Accept.allCases.enumerated().forEach {

            XCTAssertEqual(
                NetworkMe.Header.Response.accept($0.element).keyPair,
                expected[$0.offset])
        }
    }
}

