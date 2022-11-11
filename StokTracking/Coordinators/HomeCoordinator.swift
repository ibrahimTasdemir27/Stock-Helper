//
//  HomeCoordinator.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 6.11.2022.
//

import UIKit

final class HomeCoordinator : Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    var onSaveProduct = {}
    
    private let navigationController : UINavigationController
    private let tabBarController : UITabBarController
    
    init(tabBarController : UITabBarController, navigationController : UINavigationController) {
        self.tabBarController = tabBarController
        self.navigationController = navigationController
    }
    
    
    func start() {
        let tabBar = TabBarController(tabbarController: tabBarController, navigationController: navigationController)
        let homeViewModel = HomePageCellViewModel()
        let homeVC = HomeVC()
        let settingsVC = SettingsVC()
        let vc = [homeVC,settingsVC]
        onSaveProduct = homeViewModel.reload
        homeVC.viewModel = homeViewModel
        homeViewModel.coordinator = self
        tabBar.setupTabbar(vc: vc)
    }
    
    func selectItem(_ indexPath : Int) {

    }
    
    func startAddProduct() {
        let addProductCoordinator = AddProductCoordinator(navigationController: navigationController)
        addProductCoordinator.parentCoordinator = self
        addProductCoordinator.start()
        childCoordinators.append(addProductCoordinator)
    }
    
    func childDidFinish(_ childCoordinator : Coordinator) {
        if let index = childCoordinators.firstIndex(where: { coordinator -> Bool in
            return childCoordinator === coordinator
        }){
            childCoordinators.remove(at: index)
        }
    }
}
