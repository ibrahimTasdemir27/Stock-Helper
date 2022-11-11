//
//  AppCoordinator.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 6.11.2022.
//

import UIKit

protocol Coordinator : AnyObject {
    var childCoordinators : [Coordinator] {get}
    func start()
}

final class AppCoordinator : Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    
    let window : UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let tabBarController = UITabBarController()
        let navigationController = UINavigationController(rootViewController: tabBarController)
        let homeCoordinator = HomeCoordinator(tabBarController: tabBarController , navigationController: navigationController)
        homeCoordinator.start()
        childCoordinators.append(homeCoordinator)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func viewWillAppear() {
        print("Yüklennn")
    }
    
    
}
