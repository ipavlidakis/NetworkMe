//
//  ResponseValidatorProtocol.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 08/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public protocol ResponseValidatorProtocol {

    func validate(_ response: URLResponse) -> Error?
}
