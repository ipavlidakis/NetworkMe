# NetworkMe
A simple yet type-safe network framework in swift


[![Build Status](https://app.bitrise.io/app/1dc5f51a0638e1cb/status.svg?token=kLpIx1Z9l6uYJKyC_JIrsQ&branch=develop)](https://app.bitrise.io/app/1dc5f51a0638e1cb)

NetworkMe is a network library designed to be just a simple thin layer between your app and the network frameworks of each operation system. 

Some of the benefits of NetworkMe are:
* Type safe definition of your endpoints and it's requirements(including headers)
* Flexibility
* Simplicity
* Zero-dependencies
* Small size
* Availble on iOS, tvOS, watchOS and macOS
* Well tested

# How To
## Models
```swift
struct Post: Codable {

    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct CreatePost: Codable {

    let userId: Int
    let title: String
    let body: String
}
```

# Endpoints
```swift
import Foundation
import NetworkMe

enum Endpoint {

    case simpleGet
    case simplePost(userId: Int, title: String, body: String)
}

extension Endpoint: NetworkMeEndpointProtocol {

    var url: URL {

        switch self {
        case .simpleGet,
             .simplePost:
            return URL(string: "https://jsonplaceholder.typicode.com/posts")!
        }
    }

    var taskType: NetworkMe.TaskType {
        switch self {
        case .simpleGet,
             .simplePost:
            return .data
        }
    }

    var body: Data? {
        switch self {
        case .simpleGet:
            return nil
        case .simplePost(let userId, let title, let body):
            return try? JSONEncoder().encode(
                CreatePost(userId: userId, title: title, body: body))
        }
    }

    var method: NetworkMe.Method {
        switch self {
        case .simpleGet:
            return .get
        case .simplePost:
            return .post
        }
    }
    var headers: [NetworkMeHeaderProtocol] {
        return [
            NetworkMe.Header.Request.contentType(.json)
        ]
    }
}
```

## ViewController
### Execution method
```swift
func performRequest<T: Decodable>(for endpoint: Endpoint, resultItem: T.Type) {

        let router: NetworkMe.Router = NetworkMe.Router()

        router.request(endpoint: endpoint) { (result: Result<T, NetworkMe.Router.NetworkError>) in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
```