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

        public convenience init() {

            self.init(
                urlSession: URLSession.shared,
                fileRetriever: NetworkMe.FileRetriever())
        }

        public init(
            urlSession: NetworkMeURLSessionProtocol,
            fileRetriever: NetworkMeFileRetrieving) {

            self.urlSession = urlSession
            self.fileRetriever = fileRetriever
        }
    }
}

extension NetworkMe.Router: NetworkMeRouting {

    public func request<ResultItem: Decodable>(
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
        request.httpBody = endpoint.body
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
            case .upload:
                return uploadTask(with: request, endpoint: endpoint, completion: completion)
            case .download:
                return downloadTask(with: request, endpoint: endpoint, completion: completion)
            }
        }()

        task.resume()
    }
}

private extension NetworkMe.Router {

    func dataTask<ResultItem: Decodable>(
        with request: URLRequest,
        endpoint: NetworkMeEndpointProtocol,
        completion: @escaping (Result<ResultItem, NetworkError>) -> Void) -> URLSessionDataTask {

        return urlSession.dataTask(with: request) { (data, response, error) in

            guard
                let data = data
            else {
                completion(Result.failure(NetworkError.noData))
                return
            }

            do {
                let decoded = try endpoint.decoder.decode(ResultItem.self, from: data)
                completion(Result.success(decoded))
            } catch(let exception) {
                completion(Result.failure(NetworkError.parsing(exception)))
            }
        }
    }

    func uploadTask<ResultItem: Decodable>(
        with request: URLRequest,
        endpoint: NetworkMeEndpointProtocol,
        completion: @escaping (Result<ResultItem, NetworkError>) -> Void) -> URLSessionUploadTask {

        return urlSession.uploadTask(with: request, from: request.httpBody) { (data, response, error) in

            guard
                let data = data
            else {
                completion(Result.failure(NetworkError.noData))
                return
            }

            do {
                let decoded = try endpoint.decoder.decode(ResultItem.self, from: data)
                completion(Result.success(decoded))
            } catch(let exception) {
                completion(Result.failure(NetworkError.parsing(exception)))
            }
        }
    }

    func downloadTask<ResultItem: Decodable>(
        with request: URLRequest,
        endpoint: NetworkMeEndpointProtocol,
        completion: @escaping (Result<ResultItem, NetworkError>) -> Void) -> URLSessionDownloadTask {

        return urlSession.downloadTask(with: request) { [weak self] (url, response, error) in

            guard
                let url = url,
                let data = self?.fileRetriever.fetchData(from: url)
            else {
                completion(Result.failure(NetworkError.noData))
                return
            }

            do {
                let decoded = try endpoint.decoder.decode(ResultItem.self, from: data)
                completion(Result.success(decoded))
            } catch(let exception) {
                completion(Result.failure(NetworkError.parsing(exception)))
            }
        }
    }
}
