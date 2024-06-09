//
//  SearchRepository.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import Foundation
import RxSwift

protocol SearchRepository: AnyObject {
    func getTrendList(offset: Int, limit: Int) -> Single<NetworkResult<[GifModel]>>
    func getSearchList(keyword: String, offset: Int, limit: Int) -> Single<NetworkResult<[GifModel]>>
}
