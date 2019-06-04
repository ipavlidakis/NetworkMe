//
//  NetworkMeHeader+Response.swift
//  NetworkMe iOS
//
//  Created by Ilias Pavlidakis on 03/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public extension NetworkMe.Header {

    enum Response: NetworkMeHeaderProtocol {

        case cacheControl(_ cacheControls: NetworkMe.Header.Response.CacheControl)
        case custom(key: String, value: String)
        case accept(_ accept: NetworkMe.Header.Response.Accept)

        public var keyPair: NetworkMe.TransformableKeyValuePair<String, String> {
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
