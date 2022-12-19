//
//  RegulationCoordinator.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 8.11.2022.
//

import UIKit.UINavigationController

final class AddProductCoordinator : Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    var parentCoordinator : HomeCoordinator?
    
    private var navigationController : UINavigationController
    private var modalNavigationController : UINavigationController?
    
    init(_ navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.modalNavigationController = UINavigationController()
        let addProductVC = AddProductVC()
        let addProductViewModel = AddProductViewModel()
        addProductViewModel.coordinator = self
        addProductVC.delegate = parentCoordinator
        addProductVC.addProductVM = addProductViewModel
        modalNavigationController?.setViewControllers([addProductVC], animated: true)
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: true)
        }
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
    
    deinit {
        print(3 + 5)
    }
}
