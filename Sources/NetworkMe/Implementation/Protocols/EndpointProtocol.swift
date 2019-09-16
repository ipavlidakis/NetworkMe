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

    var decoder: Decoding { get }

    var requestHeaders: [HeaderProtocol] { get }

    var responseValidator: ResponseValidatorProtocol { get }

    var responseHeadersParser: HeaderParserProtocol { get }
}

public extension EndpointProtocol {

    var taskType: NetworkMe.TaskType { return .data }

    var body: Data? { return nil }

    var queryItems: [URLQueryItem]? { return nil }

    var scheme: NetworkMe.Scheme { return .https }

    var method: NetworkMe.Method { return .get }

    var cachePolicy: URLRequest.CachePolicy { return .useProtocolCachePolicy }

    var timeoutInterval: TimeInterval { return 30 }

    var decoder: Decoding { return JSONDecoder() }

    var requestHeaders: [HeaderProtocol] { return [] }

    var responseValidator: ResponseValidatorProtocol {

        return NetworkMe.HTTPResponseCodeValidator()
    }

    var responseHeadersParser: HeaderParserProtocol {

        return NetworkMe.Response.HeaderParser()
    }
}
