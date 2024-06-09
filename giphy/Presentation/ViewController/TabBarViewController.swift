//
//  TabBarViewController.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var tabBarItems: [TabBarItem] = TabBarItem.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .white
        delegate = self
    }
}

//MARK: - UITabBarControllerDelegate

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
