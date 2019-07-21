//
//  NetworkMeDecoding.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 02/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public protocol NetworkMeDecoding {

    func decode<T>(
        _ type: T.Type,
        from data: Data) throws -> T where T : Decodable
}
