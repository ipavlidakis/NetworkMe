//
//  JSONEncoder+Encoding.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 06/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

extension JSONEncoder: Encoding {

    public func customEncode<T>(_ value: T) throws -> Data? where T : Encodable {
        try self.encode(value)
    }

    public func customEncode<T>(_ value: T) throws -> Data? {
        return nil
    }
}
