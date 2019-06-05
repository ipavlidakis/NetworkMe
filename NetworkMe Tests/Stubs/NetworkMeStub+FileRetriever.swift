//
//  NetworkMeStub+FileRetriever.swift
//  NetworkMe iOS Tests
//
//  Created by Ilias Pavlidakis on 04/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation
#if os(iOS)
#if canImport(NetworkMe_iOS)
import NetworkMe_iOS
#else
import NetworkMe
#endif
#elseif os(tvOS)
import NetworkMe_tvOS
#elseif os(macOS)
import NetworkMe_macOS
#endif

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
