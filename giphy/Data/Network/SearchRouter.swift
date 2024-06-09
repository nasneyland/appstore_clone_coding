//
//  SearchRouter.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import Foundation
import Alamofire

enum SearchRouter {
    case fetchTrendResult(offset: Int, limit: Int)
    case fetchSearchResult(keyword: String, offset: Int, limit: Int)
}

extension SearchRouter: APIRouter {
    
    var baseURL: String {  return "https://api.giphy.com" }
    
    var endPoint: String {
        switch self {
        case .fetchTrendResult: return "/v1/gifs/trending"
        case .fetchSearchResult: return "/v1/gifs/search"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetchTrendResult: return .get
        case .fetchSearchResult: return .get
        }
    }
    
    var queries: [String : String]? {
        switch self {
        case .fetchTrendResult(let offset, let limit): return [
            "api_key": APIKey.GIPHY_KEY,
            "offset": "\(offset)",
            "limit": "\(limit)",
        ]
        case .fetchSearchResult(let keyword, let offset, let limit): return [
            "api_key": APIKey.GIPHY_KEY,
            "q": keyword,
            "offset": "\(offset)",
            "limit": "\(limit)",
        ]
        }
    }
}
