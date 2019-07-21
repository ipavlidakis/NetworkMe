//
//  NetworkMeHeaderResponse+CacheControl.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 02/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public extension NetworkMe.Header.Response {

    enum CacheControl {

        case mustRevalidate
        case noCache
        case noStore
        case noTransform
        case publicCache
        case privateCache
        case proxyRevalidate
        case maxAge(_ seconds: TimeInterval)
        case sMaxAge(_ seconds: TimeInterval)
    }
}


private extension NetworkMe.Header.Response.CacheControl {

    enum CustomRawValue: String, CaseIterable {
        case mustRevalidate = "must-revalidate"
        case noCache = "no-cache"
        case noStore = "no-store"
        case noTransform = "no-transform"
        case publicCache = "public"
        case privateCache = "private"
        case proxyRevalidate = "proxy-revalidate"
        case maxAge = "max-age"
        case sMaxAge = "s-maxage"
    }

    static func parseDelta(from string: String) -> TimeInterval? {

        let components = string.components(separatedBy: "=")
        guard
            components.count == 2,
            let string = components.last,
            let delta = TimeInterval(string)
        else {
            return nil
        }

        return delta
    }
}

extension NetworkMe.Header.Response.CacheControl: RawRepresentable {

    public init?(rawValue: String) {

        switch rawValue {
        case _ where rawValue.contains(CustomRawValue.mustRevalidate.rawValue):
            self = .mustRevalidate
        case _ where rawValue.contains(CustomRawValue.noCache.rawValue):
            self = .noCache
        case _ where rawValue.contains(CustomRawValue.noStore.rawValue):
            self = .noStore
        case _ where rawValue.contains(CustomRawValue.noTransform.rawValue):
            self = .noTransform
        case _ where rawValue.contains(CustomRawValue.publicCache.rawValue):
            self = .publicCache
        case _ where rawValue.contains(CustomRawValue.privateCache.rawValue):
            self = .privateCache
        case _ where rawValue.contains(CustomRawValue.proxyRevalidate.rawValue):
            self = .proxyRevalidate
        case _ where rawValue.contains(CustomRawValue.maxAge.rawValue):
            guard
                let seconds = NetworkMe.Header.Response.CacheControl.parseDelta(from: rawValue)
            else {
                fatalError("Invalid CacheControl rawValue: \(rawValue)")
            }
            self = .maxAge(seconds)
        case _ where rawValue.contains(CustomRawValue.sMaxAge.rawValue):
            guard
                let seconds = NetworkMe.Header.Response.CacheControl.parseDelta(from: rawValue)
            else {
                fatalError("Invalid CacheControl rawValue: \(rawValue)")
            }
            self = .sMaxAge(seconds)
        default:
            fatalError("Invalid CacheControl rawValue: \(rawValue)")
        }
    }

    public var rawValue: String {

        switch self {
        case .mustRevalidate:
            return CustomRawValue.mustRevalidate.rawValue
        case .noCache:
            return CustomRawValue.noCache.rawValue
        case .noStore:
            return CustomRawValue.noStore.rawValue
        case .noTransform:
            return CustomRawValue.noTransform.rawValue
        case .publicCache:
            return CustomRawValue.publicCache.rawValue
        case .privateCache:
            return CustomRawValue.privateCache.rawValue
        case .proxyRevalidate:
            return CustomRawValue.proxyRevalidate.rawValue
        case .maxAge(let delta):
            return "\(CustomRawValue.maxAge.rawValue)=\(delta)"
        case .sMaxAge(let delta):
            return "\(CustomRawValue.sMaxAge.rawValue)=\(delta)"
        }
    }
}
