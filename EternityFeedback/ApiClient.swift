//
//  ApiClient.swift
//  EternityFeedback
//
//  Created by Daniya on 05/06/2020.
//  Copyright © 2020 ZiyoMukhammad Usmonov. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case url
    case statusCode
    case standard(descrition: String)
    case decoding
    case noData
}

struct APIClient {

    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    
    func createRequest(url: String, headers: [String:String] = [:], method: String = "GET", params: [String:String] = [:]) -> Result<URLRequest, NetworkError> {
        
        guard let url = URL(string: url) else {
            return .failure(.url)
        }
         
        var request = URLRequest(url: url,
        cachePolicy: .useProtocolCachePolicy,
        timeoutInterval: 10.0)
        
        request.allHTTPHeaderFields = headers
        request.httpMethod = method
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return .success(request)
    }
    
    func sendRequest(_ request: URLRequest) -> Result<Data, NetworkError> {
        
        var result: Result<Data, NetworkError>!
        
        let semaphore = DispatchSemaphore(value: 0)
        
        urlSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode > 300 {
                result = .failure(.statusCode)
            }
            
            if (error != nil) {
                result = .failure(.standard(descrition: error!.localizedDescription))
            }
            
            if let data = data {
                result = .success(data)
            } else {
                result = .failure(.noData)
            }
            
            semaphore.signal()
            
        }).resume()
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        return result
    }
    
    /// temporary method, probably better to use decodable
    func parseResponse(data: Data) -> Result<[String: Any], NetworkError> {
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else  {
            print(String(decoding: data, as: UTF8.self))
            return .failure(.decoding)
        }
        
        return .success(json)
    }
    
    func parseResponse<T: Decodable>(data: Data) -> Result<T, NetworkError> {
        
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            print(String(decoding: data, as: UTF8.self))
            return .failure(.decoding)
        }
        
        return .success(result)
    }
}
