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
    let tabBarController = UITabBarController()
    lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController(rootViewController: tabBarController)
        return navigationController
    }()
    lazy var homeCoordinator: HomeCoordinator = {
        let homeCoordinator = HomeCoordinator(tabBarController: tabBarController , navigationController: navigationController)
        homeCoordinator.start()
        return homeCoordinator
    }()
    
    func start() {
        // -> Kullanıcı ilk defa uygulamayı indiriyorsa
        childCoordinators.append(homeCoordinator)
        if  userDefaults.bool(forKey: "firstdownload") == false {
            let modalNavigation = UINavigationController()
            let presentationController = PresentationViewController()
            presentationController.coordinator = self
            modalNavigation.setViewControllers([presentationController], animated: false)
            window.rootViewController = modalNavigation
        } else {
            window.rootViewController = navigationController
        }
        window.makeKeyAndVisible()
    }
    
    func tappedStart() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    
}
