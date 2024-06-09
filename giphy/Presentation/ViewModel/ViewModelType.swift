//
//  ViewModelType.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    associatedtype Dependencies
    
    init(dependencies: Dependencies)
    
    func transform(input: Input) -> Output
}
