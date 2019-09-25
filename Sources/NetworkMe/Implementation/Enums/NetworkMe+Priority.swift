//
//  NetworkMe+Priority.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 25/09/2019.
//

import Foundation

extension NetworkMe {

    public enum Priority: String, CaseIterable {

        case high, normal, low

        var qualityOfService: QualityOfService {

            switch self {
            case .high: return .userInitiated
            case .normal: return .default
            case .low: return .background
            }
        }

        var maxConcurrentOperations: Int {

            switch self {
            case .high: return 3
            case .normal: return 5
            case .low: return 10
            }
        }
    }
}
