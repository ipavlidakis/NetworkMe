//
//  NetworkMe+Router.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 02/06/2019.
//  Copyright © 2019 Ilias Pavlidakis. All rights reserved.
//

import Foundation

extension NetworkMe {

    public final class Router {

        private let urlSession: URLSessionProtocol
        private let fileRetriever: FileRetrieving
        private let queues: [Priority: OperationQueue]

        private var middleware: [MiddlewareProtocol]

        public convenience init() {

            let queues = Priority.allCases.reduce([:]) { (dictionary, priority) -> [Priority: OperationQueue] in

                var mutableDictionary = dictionary
                let operationQueue = OperationQueue()

                operationQueue.qualityOfService = priority.qualityOfService
                operationQueue.maxConcurrentOperationCount = priority.maxConcurrentOperations
                mutableDictionary[priority] = operationQueue

                return mutableDictionary
            }

            self.init(
                urlSession: URLSession.shared,
                fileRetriever: NetworkMe.FileRetriever(),
                middleware: [],
                queues: queues)
        }

        public init(
            urlSession: URLSessionProtocol,
            fileRetriever: FileRetrieving,
            middleware: [MiddlewareProtocol],
            queues: [Priority: OperationQueue]) {

            self.urlSession = urlSession
            self.fileRetriever = fileRetriever
            self.middleware = middleware
            self.queues = queues
        }
    }
}

extension NetworkMe.Router: Routing {

    public func add(middleware: MiddlewareProtocol) {

        self.middleware.append(middleware)
    }

    public func cancelRequests(with priorities: [NetworkMe.Priority]) {

        priorities.forEach { queues[$0]?.cancelAllOperations() }
    }

    public func request(endpoint: EndpointProtocol) {

        request(
            endpoint: endpoint,
            completion: { (_: Result<NetworkMe.EmptyDecodable, NetworkMe.Router.NetworkError>, _) in })
    }

    public func request<ResultItem: Decodable>(
        endpoint: EndpointProtocol,
        completion: @escaping (Result<ResultItem, NetworkError>, [NetworkMe.Header.Response]?) -> Void) {

        guard
            var components = URLComponents(url: endpoint.url, resolvingAgainstBaseURL: false)
            else {
                completion(.failure(NetworkMe.Router.NetworkError.invalidEndpoint(endpoint)), nil)
                return
        }

        components.scheme = endpoint.scheme.rawValue
        components.queryItems = endpoint.queryItems

        guard
            let url = components.url
            else {
                completion(.failure(NetworkMe.Router.NetworkError.invalidURLComponents(components)), nil)
                return
        }

        let request: URLRequest = {

            var urlRequest = URLRequest(
                url: url,
                cachePolicy: endpoint.cachePolicy,
                timeoutInterval: endpoint.timeoutInterval)
            urlRequest.httpMethod = endpoint.method.rawValue
            urlRequest.httpBody = endpoint.body

            let requestHeaders = endpoint.requestHeaders.map { $0.keyPair }
            urlRequest.allHTTPHeaderFields = requestHeaders.reduce([:]) { (headers, header) -> [String: String] in
                var _headers = headers
                _headers[header.key] = header.value
                return _headers
            }

            return middleware.reduce(urlRequest) { $1.apply(endpoint: endpoint, request: $0) }
        }()

        let task: URLSessionTask = {
            switch endpoint.taskType {
            case .data:
                return dataTask(with: request, endpoint: endpoint, completion: completion)
            case .upload:
                return uploadTask(with: request, endpoint: endpoint, completion: completion)
            case .download:
                return downloadTask(with: request, endpoint: endpoint, completion: completion)
            }
        }()

        enqueue(endpoint: endpoint, task: task)
    }
}

private extension NetworkMe.Router {

    func dataTask<ResultItem: Decodable>(
        with request: URLRequest,
        endpoint: EndpointProtocol,
        completion: @escaping (Result<ResultItem, NetworkError>, [NetworkMe.Header.Response]?) -> Void) -> URLSessionDataTask {

        return urlSession.dataTask(with: request) { (data, response, error) in

            let headers = endpoint.responseHeadersParser.parseHeaders(from: response)

            if let response = response,
                let validationError = endpoint.responseValidator.validate(response) {

                completion(Result.failure(NetworkError.responseValidationFailed(response, validationError)), headers)
                return
            }

            guard
                let data = data
                else {
                    completion(Result.failure(NetworkError.noData), headers)
                    return
            }

            do {
                let decoded = try endpoint.decoder.decode(ResultItem.self, from: data)
                completion(Result.success(decoded), headers)
            } catch(let exception) {
                completion(Result.failure(NetworkError.parsing(exception)), headers)
                debugPrint(String(data: data, encoding: .utf8) ?? "")
            }
        }
    }

    func uploadTask<ResultItem: Decodable>(
        with request: URLRequest,
        endpoint: EndpointProtocol,
        completion: @escaping (Result<ResultItem, NetworkError>, [NetworkMe.Header.Response]?) -> Void) -> URLSessionUploadTask {

        return urlSession.uploadTask(with: request, from: request.httpBody) { (data, response, error) in

            let headers = endpoint.responseHeadersParser.parseHeaders(from: response)

            if let response = response,
                let validationError = endpoint.responseValidator.validate(response) {

                completion(Result.failure(NetworkError.responseValidationFailed(response, validationError)), headers)
                return
            }

            guard
                let data = data
                else {
                    completion(Result.failure(NetworkError.noData), headers)
                    return
            }

            do {
                let decoded = try endpoint.decoder.decode(ResultItem.self, from: data)
                completion(Result.success(decoded), headers)
            } catch(let exception) {
                completion(Result.failure(NetworkError.parsing(exception)), headers)
                debugPrint(String(data: data, encoding: .utf8) ?? "")
            }
        }
    }

    func downloadTask<ResultItem: Decodable>(
        with request: URLRequest,
        endpoint: EndpointProtocol,
        completion: @escaping (Result<ResultItem, NetworkError>, [NetworkMe.Header.Response]?) -> Void) -> URLSessionDownloadTask {

        return urlSession.downloadTask(with: request) { [weak self] (url, response, error) in

            let headers = endpoint.responseHeadersParser.parseHeaders(from: response)

            if let response = response,
                let validationError = endpoint.responseValidator.validate(response) {

                completion(Result.failure(NetworkError.responseValidationFailed(response, validationError)), headers)
                return
            }

            guard
                let url = url,
                let data = self?.fileRetriever.fetchData(from: url)
                else {
                    completion(Result.failure(NetworkError.noData), headers)
                    return
            }

            do {
                let decoded = try endpoint.decoder.decode(ResultItem.self, from: data)
                completion(Result.success(decoded), headers)
            } catch(let exception) {
                completion(Result.failure(NetworkError.parsing(exception)), headers)
                debugPrint(String(data: data, encoding: .utf8) ?? "")
            }
        }
    }

    func enqueue(
        endpoint: EndpointProtocol,
        task: URLSessionTask) {

        guard let operationQueue = queues[endpoint.priority] else {
            assertionFailure("Queue with priority \(endpoint.priority.rawValue) doesn't exist")
            return
        }

        operationQueue.addOperation {
            task.resume()
        }
    }
}
