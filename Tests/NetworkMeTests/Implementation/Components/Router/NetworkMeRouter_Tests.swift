//
//  NetworkMeRouter_Tests.swift
//  NetworkMe iOS Tests
//
//  Created by Ilias Pavlidakis on 04/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import XCTest
import NetworkMe

final class NetworkMeRouter_Tests: XCTestCase {

    private struct CodableItem: Equatable, Codable { let value: String }

    private var stubURLSession: NetworkMe.Stub.URLSession! = NetworkMe.Stub.URLSession()
    private var stubFileRetriever: NetworkMe.Stub.FileRetriever! = NetworkMe.Stub.FileRetriever()
    private var spyQueues: [NetworkMe.Priority: NetworkMe.Stub.OperationQueue]! = [
        .high: NetworkMe.Stub.OperationQueue(),
        .normal: NetworkMe.Stub.OperationQueue(),
        .low: NetworkMe.Stub.OperationQueue(),
    ]

    override func tearDown() {

        spyQueues = nil
        super.tearDown()
    }
}

private extension NetworkMeRouter_Tests {

    enum Some {

        static let dataEndpoint = NetworkMe.Stub.Endpoint(
            stubQueryItems: [URLQueryItem(name: "key", value: "value")],
            stubScheme: NetworkMe.Scheme.https,
            stubHeaders: [NetworkMe.Header.Request.contentType(.atomXML)]
        )

        static let uploadEndpoint = NetworkMe.Stub.Endpoint(
            stubTaskType: .upload,
            stubQueryItems: [URLQueryItem(name: "key", value: "value")],
            stubScheme: NetworkMe.Scheme.https,
            stubHeaders: [NetworkMe.Header.Request.contentType(.atomXML)]
        )

        static let downloadEndpoint = NetworkMe.Stub.Endpoint(
            stubTaskType: .download,
            stubQueryItems: [URLQueryItem(name: "key", value: "value")],
            stubScheme: NetworkMe.Scheme.https,
            stubHeaders: [NetworkMe.Header.Request.contentType(.atomXML)]
        )
    }

    func makeRouter(middleware: [MiddlewareProtocol] = []) -> NetworkMe.Router {

        return NetworkMe.Router(
            urlSession: stubURLSession,
            fileRetriever: stubFileRetriever,
            middleware: middleware,
            queues: spyQueues,
            runningTasks: [:])
    }
}

extension NetworkMeRouter_Tests {

    // MARK: - addMiddleware

    func test_addMiddleware_middlewareWereCalled() {

        let router = makeRouter()
        let stubMiddleware1 = NetworkMe.Stub.Middleware()
        let stubMiddleware2 = NetworkMe.Stub.Middleware()

        router.add(middleware: stubMiddleware1)
        router.add(middleware: stubMiddleware2)
        router.request(endpoint: Some.dataEndpoint)

        [stubMiddleware1, stubMiddleware2].forEach { stubMiddleware in

            XCTAssertEqual(stubMiddleware.applyWasCalled?.endpoint.url, Some.dataEndpoint.url)
            XCTAssertEqual(stubMiddleware.applyWasCalled?.request.cachePolicy, .useProtocolCachePolicy)
            XCTAssertEqual(Some.dataEndpoint.timesCachePolicyWasCalled, 1)
            XCTAssertEqual(stubMiddleware.applyWasCalled?.request.timeoutInterval, 0)
            XCTAssertEqual(Some.dataEndpoint.timesTimeoutIntervalWasCalled, 1)
            XCTAssertEqual(stubMiddleware.applyWasCalled?.request.httpMethod?.lowercased(), Some.dataEndpoint.method.rawValue)
            XCTAssertEqual(stubMiddleware.applyWasCalled?.request.allHTTPHeaderFields, ["Content-Type": "application/atom+xml"])
            XCTAssertEqual(stubMiddleware.applyWasCalled?.request.url, URL(string: "https://test.com?key=value")!)
        }
    }

    // MARK: - cancelRequests

    func test_cancelRequests_cancelAll_allQueuesWereCancelled() {

        let router = makeRouter()

        router.cancelRequests(with: [.high, .normal, .low])

        XCTAssert(spyQueues[.low]?.cancelAllOperationsWasCalled ?? false)
        XCTAssert(spyQueues[.normal]?.cancelAllOperationsWasCalled ?? false)
        XCTAssert(spyQueues[.high]?.cancelAllOperationsWasCalled ?? false)
    }

    func test_cancelRequests_cancelNormalAndLow_highWasNotCancelled() {

        let router = makeRouter()

        router.cancelRequests(with: [.normal, .low])

        XCTAssert(spyQueues[.low]?.cancelAllOperationsWasCalled ?? false)
        XCTAssert(spyQueues[.normal]?.cancelAllOperationsWasCalled ?? false)
        XCTAssertFalse(spyQueues[.high]?.cancelAllOperationsWasCalled ?? true)
    }

    // MARK: - Middleware

    func test_request_middlewareWereCalled() {

        let stubMiddleware1 = NetworkMe.Stub.Middleware()
        let stubMiddleware2 = NetworkMe.Stub.Middleware()
        let router = makeRouter(middleware: [stubMiddleware1, stubMiddleware2])

        router.request(endpoint: Some.dataEndpoint)

        [stubMiddleware1, stubMiddleware2].forEach { stubMiddleware in

            XCTAssertEqual(stubMiddleware.applyWasCalled?.endpoint.url, Some.dataEndpoint.url)
            XCTAssertEqual(stubMiddleware.applyWasCalled?.request.cachePolicy, .useProtocolCachePolicy)
            XCTAssertEqual(stubMiddleware.applyWasCalled?.request.timeoutInterval, 0)
            XCTAssertEqual(stubMiddleware.applyWasCalled?.request.httpMethod?.lowercased(), Some.dataEndpoint.method.rawValue)
            XCTAssertEqual(stubMiddleware.applyWasCalled?.request.allHTTPHeaderFields, ["Content-Type": "application/atom+xml"])
            XCTAssertEqual(stubMiddleware.applyWasCalled?.request.url, URL(string: "https://test.com?key=value")!)
        }
    }

    // MARK: - Request without completion
    // MARK: Data task

    func test_request_withoutCompletion_dataTask_resumeWasCalledOnURLSessionTask() {

        let task = NetworkMe.Stub.URLSessionDataTask()
        stubURLSession.stubDataTaskResult = task
        let router = makeRouter()

        router.request(endpoint: Some.dataEndpoint)

        XCTAssert(task.resumeWasCalled)
        XCTAssertEqual(spyQueues[Some.dataEndpoint.priority]?.addOperationBlocks.count, 1)
    }

    func test_request_withoutCompletion_dataTask_correctRequestPassedToURLSession() {

        let router = makeRouter()

        router.request(endpoint: Some.dataEndpoint)

        XCTAssertEqual(stubURLSession.dataTaskWasCalled?.request.cachePolicy, .useProtocolCachePolicy)
        XCTAssertEqual(stubURLSession.dataTaskWasCalled?.request.timeoutInterval, 0)
        XCTAssertEqual(stubURLSession.dataTaskWasCalled?.request.httpMethod?.lowercased(), Some.dataEndpoint.method.rawValue)
        XCTAssertEqual(stubURLSession.dataTaskWasCalled?.request.allHTTPHeaderFields, ["Content-Type": "application/atom+xml"])
        XCTAssertEqual(stubURLSession.dataTaskWasCalled?.request.url, URL(string: "https://test.com?key=value")!)
    }

    // MARK: Upload task

    func test_upload_withoutCompletion_dataTask_resumeWasCalledOnURLSessionTask() {

        let task = NetworkMe.Stub.URLSessionUploadTask()
        stubURLSession.stubUploadTaskResult = task
        let router = makeRouter()

        router.request(endpoint: Some.uploadEndpoint)

        XCTAssert(task.resumeWasCalled)
        XCTAssertEqual(spyQueues[Some.uploadEndpoint.priority]?.addOperationBlocks.count, 1)
    }

    func test_request_withoutCompletion_uploadTask_correctRequestPassedToURLSession() {

        let router = makeRouter()
        let stubData = Data(base64Encoded: "test")!
        let endpoint = NetworkMe.Stub.Endpoint(
            stubTaskType: .upload,
            stubBody: stubData,
            stubQueryItems: [URLQueryItem(name: "key", value: "value")],
            stubScheme: NetworkMe.Scheme.https,
            stubHeaders: [NetworkMe.Header.Request.contentType(.atomXML)]
        )

        router.request(endpoint: endpoint)

        XCTAssertEqual(stubURLSession.uploadTaskWasCalled?.request.cachePolicy, .useProtocolCachePolicy)
        XCTAssertEqual(endpoint.timesCachePolicyWasCalled, 1)
        XCTAssertEqual(stubURLSession.uploadTaskWasCalled?.request.timeoutInterval, 0)
        XCTAssertEqual(endpoint.timesTimeoutIntervalWasCalled, 1)
        XCTAssertEqual(stubURLSession.uploadTaskWasCalled?.request.httpMethod?.lowercased(), endpoint.method.rawValue)
        XCTAssertEqual(stubURLSession.uploadTaskWasCalled?.request.allHTTPHeaderFields, ["Content-Type": "application/atom+xml"])
        XCTAssertEqual(stubURLSession.uploadTaskWasCalled?.request.url, URL(string: "https://test.com?key=value")!)
        XCTAssertEqual(stubURLSession.uploadTaskWasCalled?.data, stubData)
    }

    // MARK: Download task

    func test_request_withoutCompletion_downloadTask_resumeWasCalledOnURLSessionTask() {

        let task = NetworkMe.Stub.URLSessionDownloadTask()
        stubURLSession.stubDownloadTaskResult = task
        let router = makeRouter()

        router.request(endpoint: Some.downloadEndpoint)

        XCTAssert(task.resumeWasCalled)
        XCTAssertEqual(spyQueues[Some.downloadEndpoint.priority]?.addOperationBlocks.count, 1)
    }

    func test_request_withoutCompletion_downloadTask_correctRequestPassedToURLSession() {

        let router = makeRouter()

        router.request(endpoint: Some.downloadEndpoint)

        XCTAssertEqual(stubURLSession.downloadTaskWasCalled?.request.cachePolicy, .useProtocolCachePolicy)
        XCTAssertEqual(stubURLSession.downloadTaskWasCalled?.request.timeoutInterval, 0)
        XCTAssertEqual(stubURLSession.downloadTaskWasCalled?.request.httpMethod?.lowercased(), Some.downloadEndpoint.method.rawValue)
        XCTAssertEqual(stubURLSession.downloadTaskWasCalled?.request.allHTTPHeaderFields, ["Content-Type": "application/atom+xml"])
        XCTAssertEqual(stubURLSession.downloadTaskWasCalled?.request.url, URL(string: "https://test.com?key=value")!)
    }

    // MARK: - Request with completion

    // MARK: Data task

    func test_request_withCompletion_dataTask_resumeWasCalledOnURLSessionTask() {

        let task = NetworkMe.Stub.URLSessionDataTask()
        stubURLSession.stubDataTaskResult = task
        let router = makeRouter()

        router.request(endpoint: Some.dataEndpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>, responseHeaders) in }

        XCTAssert(task.resumeWasCalled)
        XCTAssertEqual(spyQueues[Some.dataEndpoint.priority]?.addOperationBlocks.count, 1)
    }

    func test_request_withCompletion_dataTask_correctRequestPassedToURLSession() {

       let router = makeRouter()

        router.request(endpoint: Some.dataEndpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>, responseHeaders)  in }

        XCTAssertEqual(stubURLSession.dataTaskWasCalled?.request.cachePolicy, .useProtocolCachePolicy)
        XCTAssertEqual(stubURLSession.dataTaskWasCalled?.request.timeoutInterval, 0)
        XCTAssertEqual(stubURLSession.dataTaskWasCalled?.request.httpMethod?.lowercased(), Some.dataEndpoint.method.rawValue)
        XCTAssertEqual(stubURLSession.dataTaskWasCalled?.request.allHTTPHeaderFields, ["Content-Type": "application/atom+xml"])
        XCTAssertEqual(stubURLSession.dataTaskWasCalled?.request.url, URL(string: "https://test.com?key=value")!)
    }

    func test_request_withCompletion_dataTask_urlSessionReturnsData_correctDataPassedToDecoder() {

        let stubDataResult = Data(base64Encoded: "test")!
        stubURLSession.stubDataTaskCompletionHandlerInput = (stubDataResult, nil, nil)
        let router = makeRouter()

        router.request(endpoint: Some.dataEndpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>, responseHeaders) in }

        XCTAssertEqual(Some.dataEndpoint.stubDecoder.decodeWasCalled?.data, stubDataResult)
    }

    func test_request_withCompletion_dataTask_decoderThrows_returnsParsingError() {

        stubURLSession.stubDataTaskCompletionHandlerInput = (nil, nil, nil)
        let router = makeRouter()

        var _result: Result<CodableItem, NetworkMe.Router.NetworkError>?
        router.request(endpoint: Some.dataEndpoint) { result, responseHeaders in _result = result }

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
            case .noData: XCTAssert(true)
            default: XCTFail("Invalid result received. Was expecting noData error")
            }
        }
    }

    func test_request_withCompletion_dataTask_decoderSucceeds_returnsSuccessWithExpectedItem() {

        let router = makeRouter()
        let stubResult = CodableItem(value: "test")
        stubURLSession.stubDataTaskCompletionHandlerInput = (Data(), nil, nil)
        let endpoint = NetworkMe.Stub.Endpoint()
        endpoint.stubDecoder.stubDecodeResult = stubResult

        var _result: Result<CodableItem, NetworkMe.Router.NetworkError>?
        router.request(endpoint: endpoint) { result, responseHeaders in _result = result }

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

    // MARK: Upload task

    func test_upload_withCompletion_dataTask_resumeWasCalledOnURLSessionTask() {

        let task = NetworkMe.Stub.URLSessionUploadTask()
        stubURLSession.stubUploadTaskResult = task
        let router = makeRouter()

        router.request(endpoint: Some.uploadEndpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>, _) in }

        XCTAssert(task.resumeWasCalled)
        XCTAssertEqual(spyQueues[Some.uploadEndpoint.priority]?.addOperationBlocks.count, 1)
    }

    func test_request_withCompletion_uploadTask_correctRequestPassedToURLSession() {

        let router = makeRouter()
        let stubData = Data(base64Encoded: "test")!
        let endpoint = NetworkMe.Stub.Endpoint(
            stubTaskType: .upload,
            stubBody: stubData,
            stubQueryItems: [URLQueryItem(name: "key", value: "value")],
            stubScheme: NetworkMe.Scheme.https,
            stubHeaders: [NetworkMe.Header.Request.contentType(.atomXML)]
        )

        router.request(endpoint: endpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>, _) in }

        XCTAssertEqual(stubURLSession.uploadTaskWasCalled?.request.cachePolicy, .useProtocolCachePolicy)
        XCTAssertEqual(stubURLSession.uploadTaskWasCalled?.request.timeoutInterval, 0)
        XCTAssertEqual(stubURLSession.uploadTaskWasCalled?.request.httpMethod?.lowercased(), endpoint.method.rawValue)
        XCTAssertEqual(stubURLSession.uploadTaskWasCalled?.request.allHTTPHeaderFields, ["Content-Type": "application/atom+xml"])
        XCTAssertEqual(stubURLSession.uploadTaskWasCalled?.request.url, URL(string: "https://test.com?key=value")!)
        XCTAssertEqual(stubURLSession.uploadTaskWasCalled?.data, stubData)
    }

    func test_request_withCompletion_uploadTask_urlSessionReturnsData_correctDataPassedToDecoder() {

        let stubDataResult = Data(base64Encoded: "test")!
        stubURLSession.stubUploadTaskCompletionHandlerInput = (stubDataResult, nil, nil)
        let router = makeRouter()

        router.request(endpoint: Some.uploadEndpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>, _) in }

        XCTAssertEqual(Some.uploadEndpoint.stubDecoder.decodeWasCalled?.data, stubDataResult)
    }

    func test_request_withCompletion_uploadTask_decoderThrows_returnsParsingError() {

        let router = makeRouter()
        stubURLSession.stubDataTaskCompletionHandlerInput = (nil, nil, nil)

        var _result: Result<CodableItem, NetworkMe.Router.NetworkError>?
        router.request(endpoint: Some.uploadEndpoint) { result, responseHeaders in _result = result }

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

    func test_request_withCompletion_uploadTask_decoderSucceeds_returnsSuccessWithExpectedItem() {

        let router = makeRouter()
        let stubResult = CodableItem(value: "test")
        stubURLSession.stubDataTaskCompletionHandlerInput = (Data(), nil, nil)
        let endpoint = NetworkMe.Stub.Endpoint(stubTaskType: .upload)
        endpoint.stubDecoder.stubDecodeResult = stubResult

        var _result: Result<CodableItem, NetworkMe.Router.NetworkError>?
        router.request(endpoint: endpoint) { result, responseHeaders in _result = result }

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

    // MARK: Download task

    func test_request_withCompletion_downloadTask_resumeWasCalledOnURLSessionTask() {

        let task = NetworkMe.Stub.URLSessionDownloadTask()
        stubURLSession.stubDownloadTaskResult = task
        let router = makeRouter()

        router.request(endpoint: Some.downloadEndpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>, _) in }

        XCTAssert(task.resumeWasCalled)
        XCTAssertEqual(spyQueues[Some.downloadEndpoint.priority]?.addOperationBlocks.count, 1)
    }

    func test_request_withCompletion_downloadTask_correctRequestPassedToURLSession() {

        let router = makeRouter()

        router.request(endpoint: Some.downloadEndpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>, _) in }

        XCTAssertEqual(stubURLSession.downloadTaskWasCalled?.request.cachePolicy, .useProtocolCachePolicy)
        XCTAssertEqual(stubURLSession.downloadTaskWasCalled?.request.timeoutInterval, 0)
        XCTAssertEqual(stubURLSession.downloadTaskWasCalled?.request.httpMethod?.lowercased(), Some.downloadEndpoint.method.rawValue)
        XCTAssertEqual(stubURLSession.downloadTaskWasCalled?.request.allHTTPHeaderFields, ["Content-Type": "application/atom+xml"])
        XCTAssertEqual(stubURLSession.downloadTaskWasCalled?.request.url, URL(string: "https://test.com?key=value")!)
    }

    func test_request_withCompletion_downloadTask_urlSessionReturnsData_correctURLPassedToFileRetriever() {

        let stubResult = URL(string: "test.com")
        stubURLSession.stubDownloadTaskCompletionHandlerInput = (stubResult, nil, nil)
        let router = makeRouter()

        router.request(endpoint: Some.downloadEndpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>, _) in }

        XCTAssertEqual(stubFileRetriever.fetchWasCalledWithURL, stubResult)
    }

    func test_request_withCompletion_downloadTask_urlSessionReturnsData_correctDataPassedToDecoder() {

        let stubDataResult = Data(base64Encoded: "test")!
        let stubResult = URL(string: "test.com")
        stubFileRetriever.stubFetchResult = stubDataResult
        stubURLSession.stubDownloadTaskCompletionHandlerInput = (stubResult, nil, nil)
        let router = makeRouter()

        router.request(endpoint: Some.downloadEndpoint) { (_: Result<CodableItem, NetworkMe.Router.NetworkError>, _) in }

        XCTAssertEqual(Some.downloadEndpoint.stubDecoder.decodeWasCalled?.data, stubDataResult)
    }

    func test_request_withCompletion_downloadTask_decoderThrows_returnsParsingError() {

        let router = makeRouter()
        stubURLSession.stubDataTaskCompletionHandlerInput = (nil, nil, nil)

        var _result: Result<CodableItem, NetworkMe.Router.NetworkError>?
        router.request(endpoint: Some.downloadEndpoint) { result, responseHeaders in _result = result }

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
            case .noData: XCTAssert(true)
            default: XCTFail("Invalid result received. Was expecting noData error")
            }
        }
    }

    func test_request_withCompletion_downloadTask_decoderSucceeds_returnsSuccessWithExpectedItem() {

        let router = makeRouter()
        let stubResult = CodableItem(value: "test")
        let stubDataResult = Data(base64Encoded: "test")!
        stubFileRetriever.stubFetchResult = stubDataResult
        stubURLSession.stubDataTaskCompletionHandlerInput = (Data(), nil, nil)
        let endpoint = NetworkMe.Stub.Endpoint(stubTaskType: .download)
        endpoint.stubDecoder.stubDecodeResult = stubResult

        var _result: Result<CodableItem, NetworkMe.Router.NetworkError>?
        router.request(endpoint: endpoint) { result, responseHeaders in _result = result }

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
