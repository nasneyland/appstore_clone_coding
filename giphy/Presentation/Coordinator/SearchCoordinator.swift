//
//  SearchCoordinator.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import UIKit

class SearchCoordinator: Coordinator {
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    required init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func start() {
        let dataSource = SearchDataSource()
        let repository = SearchRepositoryImpl(dataSource: dataSource)
        let usecase = SearchUseCase(repository: repository)
        let viewModel = SearchViewModel(dependencies: .init(usecase: usecase))
        let vc = SearchViewController(viewModel: viewModel)
        vc.coordinator = self
        
        presenter.pushViewController(vc, animated: false)
    }
}
