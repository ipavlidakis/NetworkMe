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

Examples
1. Get Request
Create your endpoint
```swift
import Foundation
import NetworkMe

enum Endpoint {
    case simpleGet
}

extension Endpoint: NetworkMeEndpointProtocol {

    var url: URL {
        return URL(string: "https://jsonplaceholder.typicode.com/posts")!
    }
}
```
> For the rest of the Endpoint's properties we will be using the default ones
2. Create your Codable Model
```swift
import Foundation

struct Post: Codable {
    
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
```
3. Call the router with your endpoint and a completion
```swift
let router: NetworkMe.Router = NetworkMe.Router(
urlSession: URLSession.shared,
fileRetriever: NetworkMe.FileRetriever())

router.request(endpoint: Endpoint.simpleGet) { (result: Result<[Post], NetworkMe.Router.NetworkError>) in
    
    switch result {
    case .success(let response):
        print(response)
    case .failure(let error):
        print(error)
    }
}
```
