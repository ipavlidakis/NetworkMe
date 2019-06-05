//
//  NetworkMeStub+DateFormatter.swift
//  NetworkMe iOS Tests
//
//  Created by Ilias Pavlidakis on 03/06/2019.
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

    final class DateProvider {

        var stubDateResult = Date(timeIntervalSince1970: 0)

        private(set) var localizedStringWasCalled: (date: Date, dateStyle: Foundation.DateFormatter.Style, timeStyle: Foundation.DateFormatter.Style)?
        var stubLocalizedStringResult = ""
    }
}

extension NetworkMe.Stub.DateProvider: NetworkMeDateProviding {

    var date: Date { return stubDateResult }

    func localizedString(
        from date: Date,
        dateStyle dstyle: Foundation.DateFormatter.Style,
        timeStyle tstyle: Foundation.DateFormatter.Style) -> String {

        localizedStringWasCalled = (date, dstyle, tstyle)

        return stubLocalizedStringResult
    }
}
