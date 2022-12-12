//
//  TabBarController.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 6.11.2022.
//

import UIKit

final class TabBarController {
    
    var navigationController : UINavigationController
    var tabbarController : UITabBarController
    
    init(tabbarController: UITabBarController, navigationController : UINavigationController) {
        self.tabbarController = tabbarController
        self.navigationController = navigationController
    }
    
    func setupTabbar(vc : [UIViewController]) {
        navigationController.isNavigationBarHidden = true
        tabbarController.instantiate(vc: vc)
        tabbarController.tabBar.backgroundColor = .systemGray6
        tabbarController.tabBar.barTintColor = .systemGray6
        tabbarController.tabBar.tintColor = .secondaryColor
        
    }
}


