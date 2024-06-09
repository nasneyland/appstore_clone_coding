//
//  NetworkService.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import Foundation
import Alamofire
import RxSwift

class NetworkService {
    
    private(set) var session: Session
    
    init(with session: Session = .default) {
        self.session = session
    }
    
    func request<T>(request: URLRequestConvertible) -> Single<NetworkResult<T>> where T: Decodable {
        debugPrint("[API][request] URL=\(String(describing: request.urlRequest?.url))")
        
        return Single.create { [unowned self] single in
            let request = session.request(request)
                .responseDecodable(of: T.self, decoder: JSONDecoder()) { result in
                    switch result.result {
                    case .success(let decodable):
                        single(.success(.success(decodable)))
                    case .failure(_):
                        single(.success(.error))
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

