//
//  SearchDataSource.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import Foundation
import RxSwift

class SearchDataSource {
    
    private let service: NetworkService
    
    init() {
        self.service = NetworkService()
    }
    
    //MARK: - Methods
    
    func fetchTrendResult(offset: Int, limit: Int) -> Single<NetworkResult<GifDTO>> {
        return service.request(request: SearchRouter.fetchTrendResult(offset: offset, limit: limit))
    }
    
    func fetchSearchResult(keyword: String, offset: Int, limit: Int) -> Single<NetworkResult<GifDTO>> {
        return service.request(request: SearchRouter.fetchSearchResult(keyword: keyword, offset: offset, limit: limit))
    }
}
