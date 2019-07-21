//
//  NetworkMeHeaderGeneric+Connection.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 02/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public extension NetworkMe.Header.Generic {

    enum Connection: String, CaseIterable {

        case keepAlive = "keep-alive"
        case close
    }
}
