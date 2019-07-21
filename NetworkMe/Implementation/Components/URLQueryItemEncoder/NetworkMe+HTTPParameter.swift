//
//  NetworkMe+HTTPParameter.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 19/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

extension NetworkMe {

    enum HTTPParameter: Decodable {

        case string(String)
        case bool(Bool)
        case int(Int)
        case double(Double)

        init(from decoder: Decoder) throws {

            let container = try decoder.singleValueContainer()
            if let string = try? container.decode(String.self) {
                self = .string(string)
            } else if let bool = try? container.decode(Bool.self) {
                self = .bool(bool)
            } else if let int = try? container.decode(Int.self) {
                self = .int(int)
            } else if let double = try? container.decode(Double.self) {
                self = .double(double)
            } else {
                throw NetworkMe.Router.NetworkError.invalidDataDuringDecode
            }
        }

        var description: String {

            switch self {
            case .string(let value):
                return value
            case .bool(let value):
                return value.description
            case .int(let value):
                return value.description
            case .double(let value):
                return value.description
            }
        }
    }
}
