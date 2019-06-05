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

        private let urlSession: NetworkMeURLSessionProtocol
        private let fileRetriever: NetworkMeFileRetrieving

        public init(urlSession: NetworkMeURLSessionProtocol,
                    fileRetriever: NetworkMeFileRetrieving) {

            self.urlSession = urlSession
            self.fileRetriever = fileRetriever
        }
    }
}

extension NetworkMe.Router: NetworkMeRouting {

    public func request<ResultItem: Codable>(
        endpoint: NetworkMeEndpointProtocol,
        completion: @escaping (Result<ResultItem, NetworkError>) -> Void) {

        guard
            var components = URLComponents(url: endpoint.url, resolvingAgainstBaseURL: false)
        else {
            completion(.failure(NetworkError.invalidEndpoint(endpoint)))
            return
        }

        components.scheme = endpoint.scheme.rawValue
        components.queryItems = endpoint.queryItems

        guard
            let url = components.url
        else {
            completion(.failure(NetworkError.invalidURLComponents(components)))
            return
        }

        var request = URLRequest(
            url: url,
            cachePolicy: endpoint.cachePolicy,
            timeoutInterval: endpoint.timeoutInterval)
        request.httpMethod = endpoint.method.rawValue
        let requestHeaders = endpoint.headers.map { $0.keyPair }
        request.allHTTPHeaderFields = requestHeaders.reduce([:]) { (headers, header) -> [String: String] in
                var _headers = headers
                _headers[header.key] = header.value
                return _headers
        }

        let task: URLSessionTask = {
            switch endpoint.taskType {
            case .data:
                return dataTask(with: request, endpoint: endpoint, completion: completion)
            case .upload(let bodyData):
                return uploadTask(with: request, from: bodyData, endpoint: endpoint, completion: completion)
            case .download:
                return downloadTask(with: request, endpoint: endpoint, completion: completion)
            }
        }()

        task.resume()
    }
}

private extension NetworkMe.Router {

    func dataTask<ResultItem: Codable>(
        with request: URLRequest,
        endpoint: NetworkMeEndpointProtocol,
        completion: @escaping (Result<ResultItem, NetworkError>) -> Void) -> URLSessionTask {

        return urlSession.dataTask(with: request) { (data, response, error) in

            guard
                let data = data,
                let decoded = try? endpoint.decoder.decode(ResultItem.self, from: data)
            else {
                completion(Result.failure(NetworkError.parsing))
                return
            }

            completion(Result.success(decoded))
        }
    }

    func uploadTask<ResultItem: Codable>(
        with request: URLRequest,
        from bodyData: Data?,
        endpoint: NetworkMeEndpointProtocol,
        completion: @escaping (Result<ResultItem, NetworkError>) -> Void) -> URLSessionTask {

        return urlSession.uploadTask(with: request, from: bodyData) { (data, response, error) in

            guard
                let data = data,
                let decoded = try? endpoint.decoder.decode(ResultItem.self, from: data)
            else {
                completion(Result.failure(NetworkError.parsing))
                return
            }

            completion(Result.success(decoded))
        }
    }

    func downloadTask<ResultItem: Codable>(
        with request: URLRequest,
        endpoint: NetworkMeEndpointProtocol,
        completion: @escaping (Result<ResultItem, NetworkError>) -> Void) -> URLSessionTask {

        return urlSession.downloadTask(with: request) { [weak self] (url, response, error) in

            guard
                let url = url,
                let data = self?.fileRetriever.fetchData(from: url),
                let decoded = try? endpoint.decoder.decode(ResultItem.self, from: data)
            else {
                completion(Result.failure(NetworkError.parsing))
                return
            }

            completion(Result.success(decoded))
        }
    }
}