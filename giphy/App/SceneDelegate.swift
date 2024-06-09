//
//  SceneDelegate.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window

            let navigationController = UINavigationController()
            self.window?.rootViewController = navigationController
            
            // Coordinator 패턴으로 앱 실행
            let coordinator = AppCoordinator(presenter: navigationController)
            coordinator.start()
            
            self.window?.makeKeyAndVisible()
        }
    }
}
