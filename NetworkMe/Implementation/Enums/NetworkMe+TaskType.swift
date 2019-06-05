//
//  NetworkMe+TaskType.swift
//  NetworkMe iOS
//
//  Created by Ilias Pavlidakis on 03/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

extension NetworkMe {

    public enum TaskType {

        case data
        case upload(_ bodyData: Data)
        case download
    }
}
