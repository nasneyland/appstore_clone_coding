//
//  SearchRepositoryImpl.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import Foundation
import RxSwift

class SearchRepositoryImpl: SearchRepository {
    
    private let dataSource: SearchDataSource
    
    init(dataSource: SearchDataSource) {
        self.dataSource = dataSource
    }
    
    //MARK: - Methods
    
    func getTrendList(offset: Int, limit: Int) -> Single<NetworkResult<[GifModel]>> {
        return dataSource.fetchTrendResult(offset: offset, limit: limit)
            .map { single in
                switch single {
                case .success(let value):
                    return .success(value.toEntity())
                case .error:
                    return .error
                }
            }
    }
    
    func getSearchList(keyword: String, offset: Int, limit: Int) -> Single<NetworkResult<[GifModel]>> {
        return dataSource.fetchSearchResult(keyword: keyword, offset: offset, limit: limit)
            .map { single in
                switch single {
                case .success(let value):
                    return .success(value.toEntity())
                case .error:
                    return .error
                }
            }
    }
}

