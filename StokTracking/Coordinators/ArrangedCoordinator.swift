//
//  ArrangedCoordinator.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 2.12.2022.
//

import UIKit

class ArrangedCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    private var modalNavigationController: UINavigationController?
    private let featuresModel: FeaturesModel
    var delegate: ArrangeProductDelegate?
    
    init(_ navigationController: UINavigationController, _ featuresModel: FeaturesModel) {
        self.navigationController = navigationController
        self.featuresModel = featuresModel
    }
    
    func start() {
        let arrangedProductVC = ArrangedProductVC()
        let arrangedVM = ArrangedViewModel(featuresModel)
        arrangedProductVC.arrangedVM = arrangedVM
        arrangedProductVC.delegate = delegate
        self.modalNavigationController = UINavigationController()
        modalNavigationController?.modalTransitionStyle = .coverVertical
        modalNavigationController?.setViewControllers([arrangedProductVC], animated: true)
        if let modalNavigationController = modalNavigationController {
            self.navigationController.present(modalNavigationController, animated: true)
        }
    }
    
    
}
