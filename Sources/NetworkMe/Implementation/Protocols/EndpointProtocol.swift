//
//  NetworkMeEndpointProtocol.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 02/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public protocol EndpointProtocol {

    var taskType: NetworkMe.TaskType { get }

    var url: URL { get }

    var body: Data? { get }

    var queryItems: [URLQueryItem]? { get }

    var scheme: NetworkMe.Scheme { get }

    var method: NetworkMe.Method { get }

    var cachePolicy: URLRequest.CachePolicy { get }

    var timeoutInterval: TimeInterval { get }

    var encoder: Encoding { get }

    var decoder: Decoding { get }

    var requestHeaders: [HeaderProtocol] { get }

    var responseValidator: ResponseValidatorProtocol { get }

    var responseHeadersParser: HeaderParserProtocol { get }

    var priority: NetworkMe.Priority { get }

    var cacheKey: String { get }

    var isCachable: Bool { get }
}

public extension EndpointProtocol {

    var taskType: NetworkMe.TaskType { .data }

    var body: Data? { nil }

    var queryItems: [URLQueryItem]? {nil }

    var scheme: NetworkMe.Scheme { .https }

    var method: NetworkMe.Method { .get }

    var cachePolicy: URLRequest.CachePolicy { .useProtocolCachePolicy }

    var timeoutInterval: TimeInterval { 30 }

    var encoder: Encoding { JSONEncoder() }

    var decoder: Decoding { JSONDecoder() }

    var requestHeaders: [HeaderProtocol] { [] }

    var responseValidator: ResponseValidatorProtocol { NetworkMe.HTTPResponseCodeValidator() }

    var responseHeadersParser: HeaderParserProtocol { NetworkMe.Response.HeaderParser() }

    var priority: NetworkMe.Priority { .normal }

    var cacheKey: String { url.absoluteString }

    var isCachable: Bool { true }
}
