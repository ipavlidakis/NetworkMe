//
//  NetworkMeHeaderParserProtocol.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 08/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public protocol NetworkMeHeaderParserProtocol {

    func parseHeaders(from response: URLResponse?) -> [NetworkMe.Header.Response]
}
