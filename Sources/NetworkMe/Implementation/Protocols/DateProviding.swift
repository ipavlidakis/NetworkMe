//
//  DateProviding.swift
//  NetworkMe iOS
//
//  Created by Ilias Pavlidakis on 03/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public protocol DateProviding {

    var date: Date { get }

    func localizedString(
        from date: Date,
        dateStyle dstyle: DateFormatter.Style,
        timeStyle tstyle: DateFormatter.Style) -> String
}
