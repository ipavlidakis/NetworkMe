//
//  NetworkMeStub+Endpoint.swift
//  NetworkMe iOS Tests
//
//  Created by Ilias Pavlidakis on 04/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation
#if os(iOS)
#if canImport(NetworkMe_iOS)
import NetworkMe_iOS
#else
import NetworkMe
#endif
#elseif os(tvOS)
import NetworkMe_tvOS
#elseif os(macOS)
import NetworkMe_macOS
#endif

extension NetworkMe.Stub {

    final class Endpoint {

        var stubTaskType: NetworkMe.TaskType
        var stubUrl: URL
        var stubBody: Data?
        var stubQueryItems: [URLQueryItem]?
        var stubScheme: NetworkMe.Scheme
        var stubMethod: NetworkMe.Method
        var stubCachePolicy: URLRequest.CachePolicy
        var stubTimeoutInterval: TimeInterval
        var stubDecoder: NetworkMe.Stub.Decoder
        var stubEncoder: NetworkMe.Stub.Encoder
        var stubHeaders: [NetworkMeHeaderProtocol]

        private(set) var timesTaskTypeWasCalled: Int = 0
        private(set) var timeURLWasCalled: Int = 0
        private(set) var timeBodyWasCalled: Int = 0
        private(set) var timesQueryItemsWasCalled: Int = 0
        private(set) var timesSchemeWasCalled: Int = 0
        private(set) var timesMethodWasCalled: Int = 0
        private(set) var timesCachePolicyWasCalled: Int = 0
        private(set) var timesTimeoutIntervalWasCalled: Int = 0
        private(set) var timesDecoderWasCalled: Int = 0
        private(set) var timesEncoderWasCalled: Int = 0
        private(set) var timesHeadersWasCalled: Int = 0

        init(stubTaskType: NetworkMe.TaskType = .data,
             stubUrl: URL = URL(string: "http://test.com")!,
             stubBody: Data? = nil,
             stubQueryItems: [URLQueryItem]? = nil,
             stubScheme: NetworkMe.Scheme = .http,
             stubMethod: NetworkMe.Method = .get,
             stubCachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
             stubTimeoutInterval: TimeInterval = 0,
             stubDecoder: NetworkMe.Stub.Decoder = NetworkMe.Stub.Decoder(),
             stubEncoder: NetworkMe.Stub.Encoder = NetworkMe.Stub.Encoder(),
             stubHeaders: [NetworkMeHeaderProtocol] = []) {

            self.stubTaskType = stubTaskType
            self.stubUrl = stubUrl
            self.stubBody = stubBody
            self.stubQueryItems = stubQueryItems
            self.stubScheme = stubScheme
            self.stubMethod = stubMethod
            self.stubCachePolicy = stubCachePolicy
            self.stubTimeoutInterval = stubTimeoutInterval
            self.stubDecoder = stubDecoder
            self.stubEncoder = stubEncoder
            self.stubHeaders = stubHeaders
        }

    }
}

extension NetworkMe.Stub.Endpoint: NetworkMeEndpointProtocol {

    var taskType: NetworkMe.TaskType {

        timesTaskTypeWasCalled += 1

        return stubTaskType
    }

    var url: URL {

        timeURLWasCalled += 1

        return stubUrl
    }

    var body: Data? {

        timeBodyWasCalled += 1

        return stubBody
    }

    var queryItems: [URLQueryItem]? {

        timesQueryItemsWasCalled += 1

        return stubQueryItems
    }

    var scheme: NetworkMe.Scheme {

        timesSchemeWasCalled += 1

        return stubScheme
    }

    var method: NetworkMe.Method {

        timesMethodWasCalled += 1

        return stubMethod
    }

    var cachePolicy: URLRequest.CachePolicy {

        timesCachePolicyWasCalled += 1

        return stubCachePolicy
    }

    var timeoutInterval: TimeInterval {

        timesTimeoutIntervalWasCalled += 1

        return stubTimeoutInterval
    }

    var decoder: NetworkMeDecoding {

        timesDecoderWasCalled += 1

        return stubDecoder
    }

    var encoder: NetworkMeEncoding {

        timesEncoderWasCalled += 1

        return stubEncoder
    }

    var headers: [NetworkMeHeaderProtocol] {

        timesHeadersWasCalled += 1

        return stubHeaders
    }
}
