//
//  NetworkMe+TransformableKeyValuePair.swift
//  NetworkMe iOS
//
//  Created by Ilias Pavlidakis on 03/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public extension NetworkMe {

    struct TransformableKeyValuePair<Key: Hashable, Value: Equatable>: Equatable, Hashable {

        public let key: Key
        public let value: Value

        public func hash(into hasher: inout Hasher) { hasher.combine(key) }

        init(_ key: Key, _ value: Value) {
            self.key = key
            self.value = value
        }
    }
}
