//
//  NetworkMeHeader+Response.swift
//  NetworkMe iOS
//
//  Created by Ilias Pavlidakis on 03/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public extension NetworkMe.Header {

    enum Response: HeaderProtocol, RawRepresentable {

        public typealias RawValue = NetworkMe.TransformableKeyValuePair<String, String>

        public init?(rawValue: NetworkMe.TransformableKeyValuePair<String, String>) {
            var result: NetworkMe.Header.Response?
            switch rawValue.key {
            case "Cache-Control":
                if let value = NetworkMe.Header.Response.CacheControl.init(rawValue: rawValue.value) {
                    result = .cacheControl(value)
                }
            case "Accept":
                if let value = NetworkMe.Header.Response.Accept.init(rawValue: rawValue.value) {
                    result = .accept(value)
                }
            default:
                break
            }
            self = result ?? .custom(key: rawValue.key, value: rawValue.value)
        }

        case cacheControl(_ cacheControls: NetworkMe.Header.Response.CacheControl)
        case custom(key: String, value: String)
        case accept(_ accept: NetworkMe.Header.Response.Accept)

        public var keyPair: NetworkMe.TransformableKeyValuePair<String, String> {
            return rawValue
        }

        public var rawValue: NetworkMe.TransformableKeyValuePair<String, String> {
            switch self {
            case .cacheControl(let cacheControl):
                return NetworkMe.TransformableKeyValuePair(
                    "Cache-Control",
                    cacheControl.rawValue)
            case .custom(let key, let value):
                return NetworkMe.TransformableKeyValuePair(key, value)
            case .accept(let accept):
                return NetworkMe.TransformableKeyValuePair(
                    "Accept",
                    accept.rawValue)
            }
        }
    }
}
