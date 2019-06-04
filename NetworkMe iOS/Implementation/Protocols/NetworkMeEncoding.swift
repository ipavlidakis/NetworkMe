//
//  NetworkMeEncoding.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 02/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public protocol NetworkMeEncoding {

    func encode<T>(_ value: T) throws -> Data where T : Encodable
}
