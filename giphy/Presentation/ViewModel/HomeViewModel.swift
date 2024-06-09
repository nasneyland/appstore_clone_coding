//
//  HomeViewModel.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: ViewModelType {
    
    //MARK: - Properties
    
    let dependencies: Dependencies
    
    let disposeBag = DisposeBag()
    
    struct Input {
        var fetching: Observable<Bool>
        var reachedScrollBottom: Observable<Int>
        var reloadData: Observable<Int>
    }
    
    struct Output {
        var resultList: Observable<[GifModel]>
        var isError: Observable<Void>
    }
    
    struct Dependencies {
        let usecase: SearchUseCase
    }
    
    //MARK: - Lifecycle
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    //MARK: - Configure
    
    func transform(input: Input) -> Output {
        let responseData = PublishRelay<NetworkResult<[GifModel]>>()
        let resultList = PublishRelay<[GifModel]>()
        let isError = PublishRelay<Void>()
        
        input.fetching
            .flatMap { [unowned self] _ in getTrendList() }
            .bind(to: responseData)
            .disposed(by: disposeBag)
        
        input.reachedScrollBottom
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMap { [unowned self] offset in getTrendList(offset: offset) }
            .bind(to: responseData)
            .disposed(by: disposeBag)
        
        input.reloadData
            .flatMap { [unowned self] offset in getTrendList(offset: offset) }
            .bind(to: responseData)
            .disposed(by: disposeBag)
        
        responseData
            .bind { result in
                switch result {
                case .success(let response):
                    resultList.accept(response)
                case .error:
                    isError.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        return Output(resultList: resultList.asObservable(), isError: isError.asObservable())
    }
    
    private func getTrendList(offset: Int = 0) -> Single<NetworkResult<[GifModel]>> {
        return dependencies.usecase.getTrendList(offset: offset)
    }
}
