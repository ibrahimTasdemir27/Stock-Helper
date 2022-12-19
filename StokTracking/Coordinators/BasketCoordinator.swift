//
//  BasketCoordinator.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 17.12.2022.
//

import UIKit

final class BasketCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    private var modalNavigationController: UINavigationController?
    
    init(_ navigationCommander: UINavigationController) {
        self.navigationController = navigationCommander
    }
    
    func start() {
        let basketVC = BasketVC()
        self.modalNavigationController = UINavigationController()
        self.modalNavigationController?.setViewControllers([basketVC], animated: true)
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: true)
        }
    }
}
