//
//  DateFormatter+NetworkMeDateProviding.swift
//  NetworkMe iOS
//
//  Created by Ilias Pavlidakis on 03/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

extension DateFormatter: NetworkMeDateProviding {

    public var date: Date { return Date() }

    public func localizedString(
        from date: Date,
        dateStyle dstyle: DateFormatter.Style,
        timeStyle tstyle: DateFormatter.Style) -> String {

        return DateFormatter.localizedString(
            from: date,
            dateStyle: dateStyle,
            timeStyle: timeStyle)
    }
}
