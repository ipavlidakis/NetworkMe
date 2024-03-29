//
//  NetworkMeRouter+NetworkError.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 02/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

extension NetworkMe.Router {

    public enum NetworkError: Error {

        case invalidEndpoint(_ endpoint: EndpointProtocol)
        case invalidURLComponents(_ components: URLComponents)
        case noData
        case parsing(_ error: Error)
        case responseValidationFailed(_ response: URLResponse, _ error: Error)
        case invalidDataDuringDecode
    }
}
