//
//  ArrangedCoordinator.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 2.12.2022.
//

import UIKit.UINavigationController

final class ArrangedCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    private var modalNavigationController: UINavigationController?
    private let featuresModel: FeaturesModel
    weak var parentCoordinator: HomeCoordinator?
    
    init(_ navigationController: UINavigationController, _ featuresModel: FeaturesModel) {
        self.navigationController = navigationController
        self.featuresModel = featuresModel
    }
    
    func start() {
        self.modalNavigationController = UINavigationController()
        let arrangedProductVC = ArrangedProductVC()
        let arrangedVM = ArrangedViewModel(featuresModel)
        arrangedVM.coordinator = self
        arrangedProductVC.arrangedVM = arrangedVM
        arrangedProductVC.delegate = parentCoordinator
        modalNavigationController?.modalTransitionStyle = .coverVertical
        modalNavigationController?.setViewControllers([arrangedProductVC], animated: true)
        if let modalNavigationController = modalNavigationController {
            self.navigationController.present(modalNavigationController, animated: true)
        }
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
    
    deinit {
        print("I'm deinit: ArrangedCoordinator")
    }
    
}
