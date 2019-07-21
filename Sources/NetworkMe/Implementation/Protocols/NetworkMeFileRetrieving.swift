//
//  NetworkMeFileRetrieving.swift
//  NetworkMe iOS
//
//  Created by Ilias Pavlidakis on 04/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public protocol NetworkMeFileRetrieving {

    func fetchData(from url: URL) -> Data?
}
