//
//  NetworkMeURLSessionProtocol.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 02/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public protocol NetworkMeURLSessionProtocol {

    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTask

    func uploadTask(
        with request: URLRequest,
        from bodyData: Data?,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTask

    func downloadTask(
        with request: URLRequest,
        completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionTask
}
