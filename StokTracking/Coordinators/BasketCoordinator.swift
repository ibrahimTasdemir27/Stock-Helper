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
    var parentCoordinator: HomeCoordinator?
    
    init(_ navigationCommander: UINavigationController) {
        self.navigationController = navigationCommander
    }
    let basketVC = BasketVC()
    let basketVM = BasketViewModel()
    let childVM = BasketChildViewModel()
    
    func start() {
        basketVC.basketVM = basketVM
        basketVM.coordinator = self
        childVM.coordinator = self
        childVM.delegate = basketVC
        self.modalNavigationController = UINavigationController()
        self.modalNavigationController?.setViewControllers([basketVC], animated: true)
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: true)
        }
    }
    
    func prepareChild(_ index: Int) {
        let navBarHeight = UIApplication.shared.statusBarHeight + (navigationController.navigationBar.frame.height)
        let screenHeigtPercentOne = screenHeight / 100
        let contentOffset = (basketVC.tableView.contentOffset.y / screenHeigtPercentOne) / 100
        let tableViewRowheight = basketVC.tableView.rowHeight
        let child = BasketChildVC()
        child.childVM = childVM
        child.bottom = (((navBarHeight + 12) + CGFloat(index + 1) * tableViewRowheight) / screenHeigtPercentOne) / 100 + 0.26 - contentOffset
        basketVC.view.addSubview(child.view)
        basketVC.addChild(child)
        child.didMove(toParent: basketVC)
    }
    
    func viewDidDisappear() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func didFinish() {
        navigationController.dismiss(animated: true)
        parentCoordinator?.updater()
    }
    
    deinit {
        print("I'm deinit: Basketcoordinator")
    }
    
}
