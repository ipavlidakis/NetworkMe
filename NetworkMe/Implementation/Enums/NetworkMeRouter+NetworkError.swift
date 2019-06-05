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

        case invalidEndpoint(_ endpoint: NetworkMeEndpointProtocol)
        case invalidURLComponents(_ components: URLComponents)
        case parsing
        case unauthorized
    }
}
