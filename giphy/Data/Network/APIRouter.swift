//
//  APIRouter.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import Foundation
import Alamofire

protocol APIRouter: URLRequestConvertible {
    var baseURL: String { get }
    var endPoint: String { get }
    var httpMethod: HTTPMethod { get }
    var queries: [String: String]? { get }
}

extension APIRouter {
    
    func asURLRequest() throws -> URLRequest {
        var components = URLComponents(string: baseURL)!
        components.path = endPoint
        
        if let queries = queries {
            var queryList: [URLQueryItem] = []
            queries.forEach { query in
                let query = URLQueryItem(name: query.key, value: query.value)
                queryList.append(query)
            }
            components.queryItems = queryList
        }
        
        var request = URLRequest(url: components.url!)
        request.method = httpMethod
        
        return request
    }
}

