//
//  NetworkMeStub+Decoder.swift
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

    final class Decoder: NetworkMeDecoding {

        private(set) var decodeWasCalled: (type: String, data: Data)?
        var stubDecodeResult: Any?

        func decode<T>(
            _ type: T.Type,
            from data: Data) throws -> T where T : Decodable {

            decodeWasCalled = (String(describing: type), data)

            guard let result = stubDecodeResult as? T else { throw NetworkMe.Router.NetworkError.unauthorized }

            return result
        }
    }
}

