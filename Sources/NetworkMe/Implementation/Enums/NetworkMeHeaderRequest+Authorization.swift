//
//  NetworkMeHeaderRequest+Authorization.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 02/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public extension NetworkMe.Header.Request {

    enum Authorization {
        case basic(username: String, password: String)
        case bearer(token: String)
    }
}

extension NetworkMe.Header.Request.Authorization: RawRepresentable {

    public init?(rawValue: String) {

        switch rawValue {
        case _ where rawValue.contains(":"):
            let components = rawValue.components(separatedBy: ":")
            guard
                components.count == 2,
                let username = components.first,
                let password = components.last
            else {
                fatalError("Invalid Authorization rawValue: \(rawValue)")
            }
            self = .basic(username: username, password: password)
        case _ where rawValue.hasPrefix("Bearer "):
            self = .bearer(token: rawValue.replacingOccurrences(of: "Bearer ", with: ""))
        default:
            fatalError("Invalid Authorization rawValue: \(rawValue)")
        }
    }

    public var rawValue: String {
        switch self {
        case .basic(let username, let password):
            guard let encoded = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() else {
                assertionFailure("Failed to encode basic authorization header")
                return ""
            }
            return "Basic \(encoded)"
        case .bearer(let token):
            return "Bearer \(token)"
        }
    }
}
