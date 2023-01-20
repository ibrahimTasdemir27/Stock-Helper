//
//  BasketCoordinator.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 17.12.2022.
//

import UIKit

final class ShoppingCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    private var modalNavigationController: UINavigationController?
    var parentCoordinator: HomeCoordinator?
    
    init(_ navigationCommander: UINavigationController) {
        self.navigationController = navigationCommander
    }
    let cartVC = ShoppingCartVC()
    let cartVM = ShoppingCartViewModel()
    let childVM = ShoppingChildViewModel()
    
    func start() {
        cartVC.cartVM = cartVM
        cartVM.coordinator = self
        childVM.coordinator = self
        childVM.delegate = cartVC
        self.modalNavigationController = UINavigationController()
        self.modalNavigationController?.setViewControllers([cartVC], animated: true)
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: true)
        }
    }
    
    func prepareChild(_ index: Int) {
        let navBarHeight = UIApplication.shared.statusBarHeight + (navigationController.navigationBar.frame.height)
        let screenHeigtPercentOne = screenHeight / 100
        let contentOffset = (cartVC.tableView.contentOffset.y / screenHeigtPercentOne) / 100
        let tableViewRowheight = cartVC.tableView.rowHeight
        let child = ShoppingCartChildVC()
        child.childVM = childVM
        child.bottom = (((navBarHeight + 12) + CGFloat(index + 1) * tableViewRowheight) / screenHeigtPercentOne) / 100 + 0.26 - contentOffset
        cartVC.view.addSubview(child.view)
        cartVC.addChild(child)
        child.didMove(toParent: cartVC)
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
