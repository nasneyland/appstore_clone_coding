//
//  AppCoordinator.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import UIKit

class AppCoordinator: NSObject, Coordinator {
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    required init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func start() {
        let coordinator = TabBarCoordinator(presenter: presenter)
        coordinator.start()
        
        childCoordinators.append(coordinator)
    }
}

