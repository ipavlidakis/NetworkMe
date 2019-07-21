//
//  NetworkMeStub+URLSession.swift
//  NetworkMe iOS Tests
//
//  Created by Ilias Pavlidakis on 04/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import NetworkMe

extension NetworkMe.Stub {

    final class URLSession {

        private(set) var dataTaskWasCalled: (request: URLRequest, completionHandler: (Data?, URLResponse?, Error?) -> Void)?
        var stubDataTaskCompletionHandlerInput: (Data?, URLResponse?, Error?) = (Data(), nil, nil)
        var stubDataTaskResult = NetworkMe.Stub.URLSessionDataTask()

        private(set) var uploadTaskWasCalled: (request: URLRequest, data: Data?, completionHandler: (Data?, URLResponse?, Error?) -> Void)?
        var stubUploadTaskCompletionHandlerInput: (Data?, URLResponse?, Error?) = (Data(), nil, nil)
        var stubUploadTaskResult = NetworkMe.Stub.URLSessionUploadTask()

        private(set) var downloadTaskWasCalled: (request: URLRequest, completionHandler: (URL?, URLResponse?, Error?) -> Void)?
        var stubDownloadTaskCompletionHandlerInput: (URL?, URLResponse?, Error?) = (URL(string: "localhost:80")!, nil, nil)
        var stubDownloadTaskResult = NetworkMe.Stub.URLSessionDownloadTask()
    }
}

extension NetworkMe.Stub.URLSession: NetworkMeURLSessionProtocol {

    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        dataTaskWasCalled = (request, completionHandler)
        completionHandler(stubDataTaskCompletionHandlerInput.0, stubDataTaskCompletionHandlerInput.1, stubDataTaskCompletionHandlerInput.2)
        return stubDataTaskResult
    }

    func uploadTask(
        with request: URLRequest,
        from bodyData: Data?,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask {

        uploadTaskWasCalled = (request, bodyData, completionHandler)
        completionHandler(stubUploadTaskCompletionHandlerInput.0, stubUploadTaskCompletionHandlerInput.1, stubUploadTaskCompletionHandlerInput.2)
        return stubUploadTaskResult
    }

    func downloadTask(
        with request: URLRequest,
        completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask {

        downloadTaskWasCalled = (request, completionHandler)
        completionHandler(stubDownloadTaskCompletionHandlerInput.0, stubDownloadTaskCompletionHandlerInput.1, stubDownloadTaskCompletionHandlerInput.2)
        return stubDownloadTaskResult
    }
}
