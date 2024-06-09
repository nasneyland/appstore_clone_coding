//
//  TabBarCoordinator.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import UIKit

class TabBarCoordinator: NSObject, Coordinator {
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    required init(presenter: UINavigationController) {
        self.presenter = presenter
        self.presenter.navigationBar.isHidden = true
    }

    func start() {
        let tabBarVC = TabBarViewController()
        let controllers = tabBarVC.tabBarItems.map { generateTabBarItem(item: $0) }
        tabBarVC.setViewControllers(controllers, animated: true)
        tabBarVC.selectedIndex = 4
        
        presenter.viewControllers = [tabBarVC]
    }
    
    //MARK: - Helpers
    
    private func generateTabBarItem(item: TabBarItem) -> UINavigationController {
        let navigationController = generateCoordinator(item)
        let tabItem = UITabBarItem(title: item.title,
                                   image: UIImage(systemName: item.image ?? ""),
                                   selectedImage: UIImage(systemName: item.image ?? "")?.withTintColor(.blue))
        navigationController.tabBarItem = tabItem
        return navigationController
    }
    
    private func generateCoordinator(_ item: TabBarItem) -> UINavigationController {
        let navigation = UINavigationController()
        
        switch item {
        case .home:
            let coordinator = HomeCoordinator(presenter: navigation)
            coordinator.start()
            self.childCoordinators.append(coordinator)
        case .search:
            let coordinator = SearchCoordinator(presenter: navigation)
            coordinator.start()
            self.childCoordinators.append(coordinator)
        }
        
        return navigation
    }
}

