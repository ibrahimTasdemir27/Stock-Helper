//
//  HomeCoordinator.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 6.11.2022.
//

import UIKit

protocol ArrangeProductDelegate {
    func arrengedItem(vm: FeaturesModel)
    func didFinishArrengeItem(vm: FeaturesModel)
}

final class HomeCoordinator : Coordinator , ArrangeProductDelegate {
    
    private(set) var childCoordinators: [Coordinator] = []
    let homeVC = HomeVC()
    var updater = {}
    
    private let navigationController : UINavigationController
    private let tabBarController : UITabBarController
    
    init(tabBarController : UITabBarController, navigationController : UINavigationController) {
        self.tabBarController = tabBarController
        self.navigationController = navigationController
    }
    
    
    func start() {
        let tabBar = TabBarController(tabbarController: tabBarController, navigationController: navigationController)
        let homeViewModel = FeaturesListViewModel()
        let settingsVC = SettingsVC()
        let vc = [homeVC,settingsVC]
        homeVC.viewModel = homeViewModel
        homeVC.delegate = self
        homeViewModel.coordinator = self
        tabBar.setupTabbar(vc: vc)
    }
    
    func selectItem(_ indexPath : Int) {

    }
    
    func arrengedItem(vm: FeaturesModel) {
        let arrangedCoordinator = ArrangedCoordinator(navigationController,vm)
        arrangedCoordinator.delegate = self
        childCoordinators.append(arrangedCoordinator)
        arrangedCoordinator.start()
    }
    
    func didFinishArrengeItem(vm: FeaturesModel) {
        homeVC.viewModel.updateCoredata(vm: vm)
        navigationController.dismiss(animated: true)
    }
    
    func startAddProduct() {
        let addProductCoordinator = AddProductCoordinator(navigationController,homeVC)
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
    
    func didFinishSaveProduct() {
        self.navigationController.dismiss(animated: true)
        updater()
    }
}
