//
//  NetworkeMeResponse+HeaderParser.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 08/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

extension NetworkMe.Response {

    struct HeaderParser: HeaderParserProtocol {

        func parseHeaders(from response: URLResponse?) -> [NetworkMe.Header.Response] {

            guard
                let httpResponse = response as? HTTPURLResponse,
                !httpResponse.allHeaderFields.isEmpty
            else {
                return []
            }

            return httpResponse.allHeaderFields
                .compactMap {
                    guard
                        let stringKey = $0.key as? String,
                        let stringValue = $0.value as? String
                    else { return nil }
                    return NetworkMe.TransformableKeyValuePair(stringKey, stringValue) }
                .compactMap { NetworkMe.Header.Response.init(rawValue: $0) }
        }
    }
}
