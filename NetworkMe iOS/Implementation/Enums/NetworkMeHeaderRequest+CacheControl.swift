//
//  NetworkMeHeaderRequest+CacheControl.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 02/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public extension NetworkMe.Header.Request {

    enum CacheControl {

        case noCache
        case noStore
        case maxAge(_ seconds: TimeInterval)
        case maxStale(_ seconds: TimeInterval)
        case minFresh(_ seconds: TimeInterval)
        case noTransform
        case onlyIfCached
        case cacheExtension
    }
}

private extension NetworkMe.Header.Request.CacheControl {

    enum CustomRawValue: String, CaseIterable {
        case noCache = "no-cache"
        case noStore = "no-store"
        case maxAge = "max-age"
        case maxStale = "max-stale"
        case minFresh = "min-fresh"
        case noTransform = "no-transform"
        case onlyIfCached = "only-if-cached"
        case cacheExtension = "cache-extension"
    }

    static func parseSeconds(from string: String) -> TimeInterval? {

        let components = string.components(separatedBy: "=")
        guard
            components.count == 2,
            let string = components.last,
            let seconds = TimeInterval(string)
            else {
                return nil
        }

        return seconds
    }
}

extension NetworkMe.Header.Request.CacheControl: RawRepresentable {

    public init?(rawValue: String) {

        switch rawValue {
        case _ where rawValue.contains(CustomRawValue.noCache.rawValue):
            self = .noCache
        case _ where rawValue.contains(CustomRawValue.noStore.rawValue):
            self = .noStore
        case _ where rawValue.contains(CustomRawValue.maxAge.rawValue):
            guard
                let seconds = NetworkMe.Header.Request.CacheControl.parseSeconds(from: rawValue)
                else {
                    fatalError("Invalid CacheControl rawValue: \(rawValue)")
            }
            self = .maxAge(seconds)
        case _ where rawValue.contains(CustomRawValue.maxStale.rawValue):
            guard
                let seconds = NetworkMe.Header.Request.CacheControl.parseSeconds(from: rawValue)
                else {
                    fatalError("Invalid CacheControl rawValue: \(rawValue)")
            }
            self = .maxStale(seconds)
        case _ where rawValue.contains(CustomRawValue.minFresh.rawValue):
            guard
                let seconds = NetworkMe.Header.Request.CacheControl.parseSeconds(from: rawValue)
                else {
                    fatalError("Invalid CacheControl rawValue: \(rawValue)")
            }
            self = .minFresh(seconds)
        case _ where rawValue.contains(CustomRawValue.noTransform.rawValue):
            self = .noTransform
        case _ where rawValue.contains(CustomRawValue.onlyIfCached.rawValue):
            self = .onlyIfCached
        case _ where rawValue.contains(CustomRawValue.cacheExtension.rawValue):
            self = .cacheExtension
        default:
            fatalError("Invalid CacheControl rawValue: \(rawValue)")
        }
    }

    public var rawValue: String {

        switch self {
        case .noCache:
            return CustomRawValue.noCache.rawValue
        case .noStore:
            return CustomRawValue.noStore.rawValue
        case .maxAge(let delta):
            return "\(CustomRawValue.maxAge.rawValue)=\(delta)"
        case .maxStale(let delta):
            return "\(CustomRawValue.maxStale.rawValue)=\(delta)"
        case .minFresh(let delta):
            return "\(CustomRawValue.minFresh.rawValue)=\(delta)"
        case .noTransform:
            return CustomRawValue.noTransform.rawValue
        case .onlyIfCached:
            return CustomRawValue.onlyIfCached.rawValue
        case .cacheExtension:
            return CustomRawValue.cacheExtension.rawValue
        }
    }
}
