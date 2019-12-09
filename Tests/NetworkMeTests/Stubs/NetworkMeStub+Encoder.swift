//
//  NetworkMeStub+Encoder.swift
//  NetworkMe iOS Tests
//
//  Created by Ilias Pavlidakis on 04/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import NetworkMe

extension NetworkMe.Stub {

    final class Encoder: Encoding {

        private(set) var customEncodeEncodeWasCalledWithValue: Any?
        var stubEncodeResult: Data = Data()

        func customEncode<T>(_ value: T) throws -> Data? where T : Encodable {

            customEncodeEncodeWasCalledWithValue = value

            return stubEncodeResult
        }
    }
}
