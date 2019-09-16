//
//  NetworkMe+FileRetriever.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 06/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

extension NetworkMe {

    public struct FileRetriever: FileRetrieving {

        public init() {}

        public func fetchData(from url: URL) -> Data? {

            return try? Data(contentsOf: url)
        }
    }

}
