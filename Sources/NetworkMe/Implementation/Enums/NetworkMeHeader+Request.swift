//
//  NetworkMeHeader+Request.swift
//  NetworkMe iOS
//
//  Created by Ilias Pavlidakis on 03/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public extension NetworkMe.Header {

    enum Request: HeaderProtocol {

        case cacheControl(_ cacheControl: NetworkMe.Header.Request.CacheControl)
        case custom(key: String, value: String)
        case authorization(NetworkMe.Header.Request.Authorization)
        case contentType(_ contentType: NetworkMe.Header.Request.ContentType)
        case accept(_ accept: NetworkMe.Header.Request.Accept)

        public var keyPair: NetworkMe.TransformableKeyValuePair<String, String> {
            switch self {
            case .cacheControl(let cacheControl):
                return NetworkMe.TransformableKeyValuePair(
                    "Cache-Control",
                    cacheControl.rawValue)
            case .custom(let key, let value):
                return NetworkMe.TransformableKeyValuePair(key, value)
            case .authorization(let authorization):
                return NetworkMe.TransformableKeyValuePair(
                    "Authorization",
                    authorization.rawValue)
            case .contentType(let contentType):
                return NetworkMe.TransformableKeyValuePair(
                    "Content-Type",
                    contentType.rawValue)
            case .accept(let accept):
                return NetworkMe.TransformableKeyValuePair(
                    "Accept",
                    accept.rawValue)
            }
        }
    }
}
