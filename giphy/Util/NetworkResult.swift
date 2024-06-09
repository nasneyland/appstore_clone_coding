//
//  NetworkResult.swift
//  giphy
//
//  Created by najin shin on 4/15/24.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case error
}
