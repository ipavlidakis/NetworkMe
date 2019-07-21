//
//  NetworkMeHeader+Generic.swift
//  NetworkMe iOS
//
//  Created by Ilias Pavlidakis on 03/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public extension NetworkMe.Header {

    enum Generic: NetworkMeHeaderProtocol {

        case connection(_ type: NetworkMe.Header.Generic.Connection)
        case date(_ dateProvider: NetworkMeDateProviding)

        public var keyPair: NetworkMe.TransformableKeyValuePair<String, String> {
            switch self {
            case .connection(let type):
                return NetworkMe.TransformableKeyValuePair(
                    "Connection",
                    type.rawValue)
            case .date(let dateProvider):
                return NetworkMe.TransformableKeyValuePair(
                    "Date",
                    dateProvider.localizedString(
                        from: dateProvider.date,
                        dateStyle: .long,
                        timeStyle: .none))
            }
        }
    }
}
