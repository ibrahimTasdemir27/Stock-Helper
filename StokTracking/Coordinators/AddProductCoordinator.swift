//
//  RegulationCoordinator.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 8.11.2022.
//

import UIKit

final class AddProductCoordinator : Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    var parentCoordinator : HomeCoordinator?
    
    private var navigationController : UINavigationController
    private var modalNavigationController : UINavigationController?
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let addProductVC = AddProductVC()
        let addProductViewModel = AddProductViewModel()
        self.modalNavigationController = UINavigationController()
        addProductViewModel.coordinator = self
        addProductVC.viewModel = addProductViewModel
        modalNavigationController?.setViewControllers([addProductVC], animated: true)
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: true)
        }
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func didFinishSaveProduct() {
        parentCoordinator?.onSaveProduct()
        navigationController.dismiss(animated: true)
    }
    
    
}
