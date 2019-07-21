//
//  NetworkMeResponse+Error.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 08/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

extension NetworkMe {

    enum Response {

        enum Error: Swift.Error {

            case badRequest
            case paymentRequired
            case unauthorized
            case forbidden
            case notFound
            case methodNotAllowed
            case notAcceptable
            case proyAuthenticationRequired
            case requestTimeout
            case conflict
            case gone
            case lengthRequired
            case preconditionFailed
            case requestEntityTooLarge
            case requestURITooLong
            case unsupportedMediaType
            case requestedRangeNotSatisfiable
            case expectationFailed
            case upgradeRequired
            case preconditionRequired
            case tooManyRequests
            case requestHeaderFieldsTooLarge
            case unavailableForLegalReasons
            case internalServalError
            case notImplemented
            case badGateway
            case serviceUnavailable
            case gatewayTimeout
            case httpVersionNotSupported
            case variantAlsoNegotiates
            case networkAuthenticationRequired
            case unknown
        }
    }
}
