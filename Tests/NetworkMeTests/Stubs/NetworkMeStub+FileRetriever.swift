//
//  NetworkMeStub+FileRetriever.swift
//  NetworkMe iOS Tests
//
//  Created by Ilias Pavlidakis on 04/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import NetworkMe

extension NetworkMe.Stub {

    final class FileRetriever: NetworkMeFileRetrieving {

        private(set) var fetchWasCalledWithURL: URL?
        var stubFetchResult: Data?

        func fetchData(
            from url: URL) -> Data? {

            fetchWasCalledWithURL = url

            return stubFetchResult
        }
    }
}
