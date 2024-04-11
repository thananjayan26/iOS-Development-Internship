//
//  APICall.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 11/10/23.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
    case patch
}

class APICall {
    static let instance = APICall()
    
    private init() {}
    
    func getDishes(method: HTTPMethod, url: String, completionHandler: @escaping (Result<Data, Error>) -> ()) {
        let headers = [
            "X-RapidAPI-Key": dishKey,
            "X-RapidAPI-Host": dishHost
        ]

        guard let checkedURL = URL(string: url) else {
            print("invalid URL")
            return
        }
        
        var request = URLRequest(url: checkedURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
            }
            else if let data = data {
                DispatchQueue.main.async {
                    print("checking: \(data)")
                    completionHandler(.success(data))
                }
            }
        })
        dataTask.resume()
    }
}
