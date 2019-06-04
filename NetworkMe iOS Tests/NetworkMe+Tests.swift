//
//  NetworkMe+Tests.swift
//  NetworkMe iOS Tests
//
//  Created by Ilias Pavlidakis on 03/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation
#if os(iOS)
import NetworkMe_iOS
#elseif os(tvOS)
import NetworkMe_tvOS
#else
import NetworkMe_macOS
#endif

extension NetworkMe {

    enum Stub {}
}
