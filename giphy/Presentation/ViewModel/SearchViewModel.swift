//
//  SearchViewModel.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel: ViewModelType {
    
    //MARK: - Properties
    
    let dependencies: Dependencies
    
    let disposeBag = DisposeBag()
    
    struct Input {
        var editKeyword: Observable<String>
        var tapSearch: Observable<String>
        var reachedScrollBottom: Observable<(String, Int)>
        var reloadData: Observable<(String, Int)>
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
        
        input.editKeyword
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .filter { !$0.isEmpty }
            .flatMap { [unowned self] keyword in getSearchList(keyword: keyword) }
            .bind(to: responseData)
            .disposed(by: disposeBag)
        
        input.tapSearch
            .filter { !$0.isEmpty }
            .flatMap { [unowned self] keyword in getSearchList(keyword: keyword) }
            .bind(to: responseData)
            .disposed(by: disposeBag)
        
        input.reachedScrollBottom
            .skip(1)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMap { [unowned self] (keyword, offset) in getSearchList(keyword: keyword, offset: offset) }
            .bind(to: responseData)
            .disposed(by: disposeBag)
        
        input.reloadData
            .flatMap { [unowned self] (keyword, offset) in getSearchList(keyword: keyword, offset: offset) }
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
    
    private func getSearchList(keyword: String, offset: Int = 0) -> Single<NetworkResult<[GifModel]>> {
        return dependencies.usecase.getSearchList(keyword: keyword, offset: offset)
    }
}
