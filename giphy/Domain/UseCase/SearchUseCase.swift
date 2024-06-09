//
//  SearchUseCase.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import Foundation
import RxSwift

class SearchUseCase {
    
    private let repository: SearchRepository
    
    init(repository: SearchRepository) {
        self.repository = repository
    }

    //MARK: - Methods
    
    // 홈 트렌트 gif 리스트 불러오기
    func getTrendList(offset: Int = 0, limit: Int = 30) -> Single<NetworkResult<[GifModel]>> {
        return repository.getTrendList(offset: offset, limit: limit)
    }
    
    // 키워드 검색 gif 리스트 불러오기
    func getSearchList(keyword: String = "", offset: Int = 0, limit: Int = 50) -> Single<NetworkResult<[GifModel]>> {
        return repository.getSearchList(keyword: keyword, offset: offset, limit: limit)
    }
}
