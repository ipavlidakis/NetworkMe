//
//  NetworkMe+URLQueryItemEncoder.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 19/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

extension NetworkMe {

    public struct URLQueryItemEncoder {

        public init() {}

        public func encode<T: Encodable>(
            _ encodable: T) throws -> [URLQueryItem] {

            let parametersData = try JSONEncoder().encode(encodable)

            let parameters = try JSONDecoder().decode(
                [String: NetworkMe.HTTPParameter].self,
                from: parametersData)

            return parameters
                .map { URLQueryItem(name: $0, value: $1.description) }
        }
    }
}
