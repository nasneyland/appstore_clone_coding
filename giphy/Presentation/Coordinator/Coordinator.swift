//
//  Coordinator.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var presenter: UINavigationController { get set }
    
    var childCoordinators: [Coordinator] { get set }
    
    init(presenter: UINavigationController)
    
    func start()
}

