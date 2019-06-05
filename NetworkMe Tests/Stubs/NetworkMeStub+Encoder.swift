//
//  NetworkMeStub+Encoder.swift
//  NetworkMe iOS Tests
//
//  Created by Ilias Pavlidakis on 04/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation
#if os(iOS)
#if canImport(NetworkMe_iOS)
import NetworkMe_iOS
#else
import NetworkMe
#endif
#elseif os(tvOS)
import NetworkMe_tvOS
#elseif os(macOS)
import NetworkMe_macOS
#endif

extension NetworkMe.Stub {

    final class Encoder: NetworkMeEncoding {

        private(set) var encodeWasCalledWithValue: Any?
        var stubEncodeResult: Data = Data()

        func encode<T>(_ value: T) throws -> Data where T : Encodable {

            encodeWasCalledWithValue = value

            return stubEncodeResult
        }
    }
}
