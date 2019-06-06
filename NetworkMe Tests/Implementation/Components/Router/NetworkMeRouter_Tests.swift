//
//  NetworkMeRouter_Tests.swift
//  NetworkMe iOS Tests
//
//  Created by Ilias Pavlidakis on 04/06/2019.
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

final class NetworkMeRouter_Tests: XCTestCase {

    private struct CodableItem: Equatable, Codable { let value: String }

    // MARK: -

    // MARK: - Data task

    func test_request_dataTask_resumeWasCalledOnURLSessionTask() {

        let stubURLSession = NetworkMe.Stub.URLSession()
        let task = NetworkMe.Stub.URLSessionDataTask()
        stubURLSession.stubDataTaskResult = task
        let stubFileRetriever = NetworkMe.Stub.FileRetriever()
        let router = NetworkMe.Router(
            urlSession: stubURLSession,
            fileRetriever: stubFileRetriever)
        let endpoint = NetworkMe.Stub.Endpoint(
            stubQueryItems: [URLQueryItem(name: "key", value: "value")],
            stubScheme: NetworkMe.Scheme.https,
            stubHeaders: [NetworkMe.Header.Request.contentType(.atomXML)]
        )

        router.request(endpoint: endpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>) in }

        XCTAssert(task.resumeWasCalled)
    }

    func test_request_dataTask_correctRequestPassedToURLSession() {

        let stubURLSession = NetworkMe.Stub.URLSession()
        let stubFileRetriever = NetworkMe.Stub.FileRetriever()
        let router = NetworkMe.Router(
            urlSession: stubURLSession,
            fileRetriever: stubFileRetriever)
        let endpoint = NetworkMe.Stub.Endpoint(
            stubQueryItems: [URLQueryItem(name: "key", value: "value")],
            stubScheme: NetworkMe.Scheme.https,
            stubHeaders: [NetworkMe.Header.Request.contentType(.atomXML)]
        )

        router.request(endpoint: endpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>) in }

        XCTAssertEqual(stubURLSession.dataTaskWasCalled?.request.cachePolicy, .useProtocolCachePolicy)
        XCTAssertEqual(endpoint.timesCachePolicyWasCalled, 1)
        XCTAssertEqual(stubURLSession.dataTaskWasCalled?.request.timeoutInterval, 0)
        XCTAssertEqual(endpoint.timesTimeoutIntervalWasCalled, 1)
        XCTAssertEqual(stubURLSession.dataTaskWasCalled?.request.httpMethod?.lowercased(), endpoint.method.rawValue)
        XCTAssertEqual(stubURLSession.dataTaskWasCalled?.request.allHTTPHeaderFields, ["Content-Type": "application/atom+xml"])
        XCTAssertEqual(stubURLSession.dataTaskWasCalled?.request.url, URL(string: "https://test.com?key=value")!)
    }

    func test_request_dataTask_urlSessionReturnsData_correctdataPassedToDecoder() {

        let stubURLSession = NetworkMe.Stub.URLSession()
        let stubFileRetriever = NetworkMe.Stub.FileRetriever()
        let router = NetworkMe.Router(
            urlSession: stubURLSession,
            fileRetriever: stubFileRetriever)
        let stubDataResult = Data(base64Encoded: "test")!
        stubURLSession.stubDataTaskCompletionHandlerInput = (stubDataResult, nil, nil)
        let endpoint = NetworkMe.Stub.Endpoint()

        router.request(endpoint: endpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>) in }

        XCTAssertEqual(endpoint.stubDecoder.decodeWasCalled?.data, stubDataResult)
    }

    func test_request_dataTask_decoderThrows_returnsParsingError() {

        let stubURLSession = NetworkMe.Stub.URLSession()
        let stubFileRetriever = NetworkMe.Stub.FileRetriever()
        let router = NetworkMe.Router(
            urlSession: stubURLSession,
            fileRetriever: stubFileRetriever)
        stubURLSession.stubDataTaskCompletionHandlerInput = (nil, nil, nil)
        let endpoint = NetworkMe.Stub.Endpoint()

        var _result: Result<CodableItem, NetworkMe.Router.NetworkError>?
        router.request(endpoint: endpoint) { _result = $0 }

        guard
            let result = _result
        else {
            return XCTFail("Invalid result received. Was expecting parsing error")
        }

        switch result {
        case .success(_):
            XCTFail("Invalid result received. Was expecting parsing error")
        case .failure(let error):
            switch error {
            case .parsing: XCTAssert(true)
            default: XCTFail("Invalid result received. Was expecting parsing error")
            }
        }
    }

    func test_request_dataTask_decoderSucceeds_returnsSuccessWithExpectedItem() {

        let stubURLSession = NetworkMe.Stub.URLSession()
        let stubFileRetriever = NetworkMe.Stub.FileRetriever()
        let router = NetworkMe.Router(
            urlSession: stubURLSession,
            fileRetriever: stubFileRetriever)
        let stubResult = CodableItem(value: "test")
        stubURLSession.stubDataTaskCompletionHandlerInput = (Data(), nil, nil)
        let endpoint = NetworkMe.Stub.Endpoint()
        endpoint.stubDecoder.stubDecodeResult = stubResult

        var _result: Result<CodableItem, NetworkMe.Router.NetworkError>?
        router.request(endpoint: endpoint) { _result = $0 }

        guard
            let result = _result
            else {
                return XCTFail("Invalid result received. Was expecting parsing error")
        }

        switch result {
        case .failure(_):
            XCTFail("Invalid result received. Was expecting success with CodableItem")
        case .success(let item):
            XCTAssertEqual(item, stubResult)
        }
    }

    // MARK: - Upload task

    func test_upload_dataTask_resumeWasCalledOnURLSessionTask() {

        let stubURLSession = NetworkMe.Stub.URLSession()
        let task = NetworkMe.Stub.URLSessionUploadTask()
        stubURLSession.stubUploadTaskResult = task
        let stubFileRetriever = NetworkMe.Stub.FileRetriever()
        let router = NetworkMe.Router(
            urlSession: stubURLSession,
            fileRetriever: stubFileRetriever)
        let endpoint = NetworkMe.Stub.Endpoint(
            stubTaskType: .upload,
            stubQueryItems: [URLQueryItem(name: "key", value: "value")],
            stubScheme: NetworkMe.Scheme.https,
            stubHeaders: [NetworkMe.Header.Request.contentType(.atomXML)]
        )

        router.request(endpoint: endpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>) in }

        XCTAssert(task.resumeWasCalled)
    }

    func test_request_uploadTask_correctRequestPassedToURLSession() {

        let stubURLSession = NetworkMe.Stub.URLSession()
        let stubFileRetriever = NetworkMe.Stub.FileRetriever()
        let router = NetworkMe.Router(
            urlSession: stubURLSession,
            fileRetriever: stubFileRetriever)
        let stubData = Data(base64Encoded: "test")!
        let endpoint = NetworkMe.Stub.Endpoint(
            stubTaskType: .upload,
            stubBody: stubData,
            stubQueryItems: [URLQueryItem(name: "key", value: "value")],
            stubScheme: NetworkMe.Scheme.https,
            stubHeaders: [NetworkMe.Header.Request.contentType(.atomXML)]
        )

        router.request(endpoint: endpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>) in }

        XCTAssertEqual(stubURLSession.uploadTaskWasCalled?.request.cachePolicy, .useProtocolCachePolicy)
        XCTAssertEqual(endpoint.timesCachePolicyWasCalled, 1)
        XCTAssertEqual(stubURLSession.uploadTaskWasCalled?.request.timeoutInterval, 0)
        XCTAssertEqual(endpoint.timesTimeoutIntervalWasCalled, 1)
        XCTAssertEqual(stubURLSession.uploadTaskWasCalled?.request.httpMethod?.lowercased(), endpoint.method.rawValue)
        XCTAssertEqual(stubURLSession.uploadTaskWasCalled?.request.allHTTPHeaderFields, ["Content-Type": "application/atom+xml"])
        XCTAssertEqual(stubURLSession.uploadTaskWasCalled?.request.url, URL(string: "https://test.com?key=value")!)
        XCTAssertEqual(stubURLSession.uploadTaskWasCalled?.data, stubData)
    }

    func test_request_uploadTask_urlSessionReturnsData_correctdataPassedToDecoder() {

        let stubURLSession = NetworkMe.Stub.URLSession()
        let stubFileRetriever = NetworkMe.Stub.FileRetriever()
        let router = NetworkMe.Router(
            urlSession: stubURLSession,
            fileRetriever: stubFileRetriever)
        let stubDataResult = Data(base64Encoded: "test")!
        stubURLSession.stubUploadTaskCompletionHandlerInput = (stubDataResult, nil, nil)
        let endpoint = NetworkMe.Stub.Endpoint(stubTaskType: .upload)

        router.request(endpoint: endpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>) in }

        XCTAssertEqual(endpoint.stubDecoder.decodeWasCalled?.data, stubDataResult)
    }

    func test_request_uploadTask_decoderThrows_returnsParsingError() {

        let stubURLSession = NetworkMe.Stub.URLSession()
        let stubFileRetriever = NetworkMe.Stub.FileRetriever()
        let router = NetworkMe.Router(
            urlSession: stubURLSession,
            fileRetriever: stubFileRetriever)
        stubURLSession.stubDataTaskCompletionHandlerInput = (nil, nil, nil)
        let endpoint = NetworkMe.Stub.Endpoint(stubTaskType: .upload)

        var _result: Result<CodableItem, NetworkMe.Router.NetworkError>?
        router.request(endpoint: endpoint) { _result = $0 }

        guard
            let result = _result
            else {
                return XCTFail("Invalid result received. Was expecting parsing error")
        }

        switch result {
        case .success(_):
            XCTFail("Invalid result received. Was expecting parsing error")
        case .failure(let error):
            switch error {
            case .parsing: XCTAssert(true)
            default: XCTFail("Invalid result received. Was expecting parsing error")
            }
        }
    }

    func test_request_uploadTask_decoderSucceeds_returnsSuccessWithExpectedItem() {

        let stubURLSession = NetworkMe.Stub.URLSession()
        let stubFileRetriever = NetworkMe.Stub.FileRetriever()
        let router = NetworkMe.Router(
            urlSession: stubURLSession,
            fileRetriever: stubFileRetriever)
        let stubResult = CodableItem(value: "test")
        stubURLSession.stubDataTaskCompletionHandlerInput = (Data(), nil, nil)
        let endpoint = NetworkMe.Stub.Endpoint(stubTaskType: .upload)
        endpoint.stubDecoder.stubDecodeResult = stubResult

        var _result: Result<CodableItem, NetworkMe.Router.NetworkError>?
        router.request(endpoint: endpoint) { _result = $0 }

        guard
            let result = _result
            else {
                return XCTFail("Invalid result received. Was expecting parsing error")
        }

        switch result {
        case .failure(_):
            XCTFail("Invalid result received. Was expecting success with CodableItem")
        case .success(let item):
            XCTAssertEqual(item, stubResult)
        }
    }

    // MARK: - Download task

    func test_request_downloadTask_resumeWasCalledOnURLSessionTask() {

        let stubURLSession = NetworkMe.Stub.URLSession()
        let task = NetworkMe.Stub.URLSessionDownloadTask()
        stubURLSession.stubDownloadTaskResult = task
        let stubFileRetriever = NetworkMe.Stub.FileRetriever()
        let router = NetworkMe.Router(
            urlSession: stubURLSession,
            fileRetriever: stubFileRetriever)
        let endpoint = NetworkMe.Stub.Endpoint(
            stubTaskType: .download,
            stubQueryItems: [URLQueryItem(name: "key", value: "value")],
            stubScheme: NetworkMe.Scheme.https,
            stubHeaders: [NetworkMe.Header.Request.contentType(.atomXML)]
        )

        router.request(endpoint: endpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>) in }

        XCTAssert(task.resumeWasCalled)
    }

    func test_request_downloadTask_correctRequestPassedToURLSession() {

        let stubURLSession = NetworkMe.Stub.URLSession()
        let stubFileRetriever = NetworkMe.Stub.FileRetriever()
        let router = NetworkMe.Router(
            urlSession: stubURLSession,
            fileRetriever: stubFileRetriever)
        let endpoint = NetworkMe.Stub.Endpoint(
            stubTaskType: .download,
            stubQueryItems: [URLQueryItem(name: "key", value: "value")],
            stubScheme: NetworkMe.Scheme.https,
            stubHeaders: [NetworkMe.Header.Request.contentType(.atomXML)]
        )

        router.request(endpoint: endpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>) in }

        XCTAssertEqual(stubURLSession.downloadTaskWasCalled?.request.cachePolicy, .useProtocolCachePolicy)
        XCTAssertEqual(endpoint.timesCachePolicyWasCalled, 1)
        XCTAssertEqual(stubURLSession.downloadTaskWasCalled?.request.timeoutInterval, 0)
        XCTAssertEqual(endpoint.timesTimeoutIntervalWasCalled, 1)
        XCTAssertEqual(stubURLSession.downloadTaskWasCalled?.request.httpMethod?.lowercased(), endpoint.method.rawValue)
        XCTAssertEqual(stubURLSession.downloadTaskWasCalled?.request.allHTTPHeaderFields, ["Content-Type": "application/atom+xml"])
        XCTAssertEqual(stubURLSession.downloadTaskWasCalled?.request.url, URL(string: "https://test.com?key=value")!)
    }

    func test_request_downloadTask_urlSessionReturnsData_correctURLPassedToFileRetriever() {

        let stubURLSession = NetworkMe.Stub.URLSession()
        let stubFileRetriever = NetworkMe.Stub.FileRetriever()
        let router = NetworkMe.Router(
            urlSession: stubURLSession,
            fileRetriever: stubFileRetriever)
        let stubResult = URL(string: "test.com")
        stubURLSession.stubDownloadTaskCompletionHandlerInput = (stubResult, nil, nil)
        let endpoint = NetworkMe.Stub.Endpoint(stubTaskType: .download)

        router.request(endpoint: endpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>) in }

        XCTAssertEqual(stubFileRetriever.fetchWasCalledWithURL, stubResult)
    }

    func test_request_downloadTask_urlSessionReturnsData_correctdataPassedToDecoder() {

        let stubURLSession = NetworkMe.Stub.URLSession()
        let stubFileRetriever = NetworkMe.Stub.FileRetriever()
        let router = NetworkMe.Router(
            urlSession: stubURLSession,
            fileRetriever: stubFileRetriever)
        let stubResult = URL(string: "test.com")
        let stubDataResult = Data(base64Encoded: "test")!
        stubFileRetriever.stubFetchResult = stubDataResult
        stubURLSession.stubDownloadTaskCompletionHandlerInput = (stubResult, nil, nil)
        let endpoint = NetworkMe.Stub.Endpoint(stubTaskType: .download)

        router.request(endpoint: endpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>) in }

        XCTAssertEqual(endpoint.stubDecoder.decodeWasCalled?.data, stubDataResult)
    }

    func test_request_downloadTask_decoderThrows_returnsParsingError() {

        let stubURLSession = NetworkMe.Stub.URLSession()
        let stubFileRetriever = NetworkMe.Stub.FileRetriever()
        let router = NetworkMe.Router(
            urlSession: stubURLSession,
            fileRetriever: stubFileRetriever)
        stubURLSession.stubDataTaskCompletionHandlerInput = (nil, nil, nil)
        let endpoint = NetworkMe.Stub.Endpoint(stubTaskType: .download)

        var _result: Result<CodableItem, NetworkMe.Router.NetworkError>?
        router.request(endpoint: endpoint) { _result = $0 }

        guard
            let result = _result
            else {
                return XCTFail("Invalid result received. Was expecting parsing error")
        }

        switch result {
        case .success(_):
            XCTFail("Invalid result received. Was expecting parsing error")
        case .failure(let error):
            switch error {
            case .parsing: XCTAssert(true)
            default: XCTFail("Invalid result received. Was expecting parsing error")
            }
        }
    }

    func test_request_downloadTask_decoderSucceeds_returnsSuccessWithExpectedItem() {

        let stubURLSession = NetworkMe.Stub.URLSession()
        let stubFileRetriever = NetworkMe.Stub.FileRetriever()
        let router = NetworkMe.Router(
            urlSession: stubURLSession,
            fileRetriever: stubFileRetriever)
        let stubResult = CodableItem(value: "test")
        let stubDataResult = Data(base64Encoded: "test")!
        stubFileRetriever.stubFetchResult = stubDataResult
        stubURLSession.stubDataTaskCompletionHandlerInput = (Data(), nil, nil)
        let endpoint = NetworkMe.Stub.Endpoint(stubTaskType: .download)
        endpoint.stubDecoder.stubDecodeResult = stubResult

        var _result: Result<CodableItem, NetworkMe.Router.NetworkError>?
        router.request(endpoint: endpoint) { _result = $0 }

        guard
            let result = _result
            else {
                return XCTFail("Invalid result received. Was expecting parsing error")
        }

        switch result {
        case .failure(_):
            XCTFail("Invalid result received. Was expecting success with CodableItem")
        case .success(let item):
            XCTAssertEqual(item, stubResult)
        }
    }
}
