//
//  NetworkMe+HTTPResponseCodeValidator.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 08/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

extension NetworkMe {

    struct HTTPResponseCodeValidator {

        private let validStatusCodeRange: ClosedRange<Int> = 200...399
    }
}

extension NetworkMe.HTTPResponseCodeValidator: NetworMeResponseValidatorProtocol {

    func validate(_ response: URLResponse) -> Error? {

        guard
            let httpResponse = response as? HTTPURLResponse
        else {
            return nil
        }

        switch httpResponse.statusCode {
        case validStatusCodeRange:
            return nil
        case 400:
            return NetworkMe.Response.Error.badRequest
        case 401:
            return NetworkMe.Response.Error.unauthorized
        case 402:
            return NetworkMe.Response.Error.paymentRequired
        case 403:
            return NetworkMe.Response.Error.forbidden
        case 404:
            return NetworkMe.Response.Error.notFound
        case 405:
            return NetworkMe.Response.Error.methodNotAllowed
        case 406:
            return NetworkMe.Response.Error.notAcceptable
        case 407:
            return NetworkMe.Response.Error.proyAuthenticationRequired
        case 408:
            return NetworkMe.Response.Error.requestTimeout
        case 409:
            return NetworkMe.Response.Error.conflict
        case 410:
            return NetworkMe.Response.Error.gone
        case 411:
            return NetworkMe.Response.Error.lengthRequired
        case 412:
            return NetworkMe.Response.Error.preconditionFailed
        case 413:
            return NetworkMe.Response.Error.requestEntityTooLarge
        case 414:
            return NetworkMe.Response.Error.requestURITooLong
        case 415:
            return NetworkMe.Response.Error.unsupportedMediaType
        case 416:
            return NetworkMe.Response.Error.requestedRangeNotSatisfiable
        case 417:
            return NetworkMe.Response.Error.expectationFailed
        case 426:
            return NetworkMe.Response.Error.upgradeRequired
        case 428:
            return NetworkMe.Response.Error.preconditionRequired
        case 429:
            return NetworkMe.Response.Error.tooManyRequests
        case 431:
            return NetworkMe.Response.Error.requestHeaderFieldsTooLarge
        case 451:
            return NetworkMe.Response.Error.unavailableForLegalReasons
        case 500:
            return NetworkMe.Response.Error.internalServalError
        case 501:
            return NetworkMe.Response.Error.notImplemented
        case 502:
            return NetworkMe.Response.Error.badGateway
        case 503:
            return NetworkMe.Response.Error.serviceUnavailable
        case 504:
            return NetworkMe.Response.Error.gatewayTimeout
        case 505:
            return NetworkMe.Response.Error.httpVersionNotSupported
        case 506:
            return NetworkMe.Response.Error.variantAlsoNegotiates
        case 511:
            return NetworkMe.Response.Error.networkAuthenticationRequired
        default:
            return NetworkMe.Response.Error.unknown
        }
    }
}
