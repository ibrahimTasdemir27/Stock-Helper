//
//  HomeCoordinator.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 6.11.2022.
//

import UIKit

protocol ArrangeProductDelegate {
    func arrengedItem(vm: FeaturesModel)
    func didFinishArrengeItem(vm: FeaturesModel, nav: UINavigationController)
}

protocol FinishAddProductDidSave {
    func didSaveProduct(vm: FeaturesModel)
}


final class HomeCoordinator : Coordinator , ArrangeProductDelegate {
    
    private(set) var childCoordinators: [Coordinator] = []
    var coreDataManager = CoreDataManager.shared
    
    var updater = {}
    
    
    
    private let navigationController : UINavigationController
    private let tabBarController : UITabBarController
    
    init(tabBarController : UITabBarController, navigationController : UINavigationController) {
        self.tabBarController = tabBarController
        self.navigationController = navigationController
    }
    
    func start() {
        let homeVC = HomeVC()
        let tabBar = TabBarController(tabbarController: tabBarController, navigationController: navigationController)
        let homeViewModel = FeaturesListViewModel()
        let settingsVC = SettingsVC()
        let settingsVM = SettingsViewModel()
        settingsVM.coordinator = self
        settingsVC.settingsVM = settingsVM
        let vc = [homeVC,settingsVC]
        homeVC.viewModel = homeViewModel
        homeVC.delegate = self
        homeViewModel.coordinator = self
        tabBar.setupTabbar(vc: vc)
    }
    
    func selectItem(_ indexPath : Int) {

    }
    
    func tappedCart() {
        let shoppingCoordinator = ShoppingCoordinator(navigationController)
        shoppingCoordinator.start()
        shoppingCoordinator.parentCoordinator = self
        self.childCoordinators.append(shoppingCoordinator)
    }
    
    func arrengedItem(vm: FeaturesModel) {
        let arrangedCoordinator = ArrangedCoordinator(navigationController,vm)
        arrangedCoordinator.parentCoordinator = self
        childCoordinators.append(arrangedCoordinator)
        arrangedCoordinator.start()
    }
    
    func didFinishArrengeItem(vm: FeaturesModel, nav: UINavigationController) {
        coreDataManager.update(vm)
        nav.dismiss(animated: true)
        updater()
    }
    
    func startAddProduct() {
        let addProductCoordinator = AddProductCoordinator(navigationController)
        addProductCoordinator.parentCoordinator = self
        addProductCoordinator.start()
        childCoordinators.append(addProductCoordinator)
    }
    
    func childDidFinish(_ childCoordinator : Coordinator) {
        if let index = childCoordinators.firstIndex(where: { coordinator -> Bool in
            return childCoordinator === coordinator
        }){
            childCoordinators.remove(at: index)
            print("coordinators",childCoordinators)
        }
    }
    
    //MARK: -> Settings
    
    func didSelectSystatistic() {
        let systatisticCoordinator = SystatisticCoordinator(navigationController)
        systatisticCoordinator.parentCoordinator = self
        childCoordinators.append(systatisticCoordinator)
        systatisticCoordinator.start()
    }
    
   
}

extension HomeCoordinator: FinishAddProductDidSave {
    func didSaveProduct(vm: FeaturesModel) {
        coreDataManager.save(vm)
        self.navigationController.dismiss(animated: true)
        updater()
    }
}
