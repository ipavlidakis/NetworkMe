//
//  NetworkMeHeaderRequest+Accept.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 07/10/2019.
//

import Foundation

public extension NetworkMe.Header.Request {

    enum Accept: String, CaseIterable {

        case formUnencoded = "application/x-www-form-urlencoded"
        case xml = "application/xml"
        case xmlDTD = "application/xml-dtd"
        case xopXML = "application/xop+xml"
        case zip = "application/zip"
        case gzip = "application/gzip"
        case graphql = "application/graphql"
        case postscript = "application/postscript"
        case rdfXML = "application/rdf+xml"
        case rssXML = "application/rss+xml"
        case soapXML = "application/soap+xml"
        case fontWoff = "application/fornt-woff"
        case yaml = "application/x-yaml"
        case xhtmlXML = "application/xhtml+xml"
        case atomXML = "application/atom+xml"
        case ecmascript = "application/ecmascript"
        case json = "application/json"
        case javascript = "application/javascript"
        case octetStream = "application/octet-stream"
        case ogg = "application/ogg"
        case pdf = "application/pdf"
        case jpeg = "image/jpeg"
        case png = "image/png"
        case anything = "*/*"
    }
}
