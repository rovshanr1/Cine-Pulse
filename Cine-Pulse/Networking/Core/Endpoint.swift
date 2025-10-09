//
//  Endpoint.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 04.10.25.
//

import Foundation

//MARK: - Enpoint
protocol Endpoint{
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
}

enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

//MARK: - Default behavior for endpoint protocol
extension Endpoint{
    var headers: [String: String]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    
    
    func asURLRequest() throws -> URLRequest{
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw NetworkErrors.invalidURL
        }
        
        urlComponents.path = urlComponents.path.appending(path)
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else{
            throw NetworkErrors.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        return request
    }
}
