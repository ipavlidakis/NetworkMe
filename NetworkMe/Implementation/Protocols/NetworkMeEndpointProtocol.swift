//
//  NetworkMeEndpointProtocol.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 02/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public protocol NetworkMeEndpointProtocol {

    var taskType: NetworkMe.TaskType { get }

    var url: URL { get }

    var body: Data? { get }

    var queryItems: [URLQueryItem]? { get }

    var scheme: NetworkMe.Scheme { get }

    var method: NetworkMe.Method { get }

    var cachePolicy: URLRequest.CachePolicy { get }

    var timeoutInterval: TimeInterval { get }

    var decoder: NetworkMeDecoding { get }

    var encoder: NetworkMeEncoding { get }

    var headers: [NetworkMeHeaderProtocol] { get }
}
