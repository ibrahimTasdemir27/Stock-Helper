//
//  CalendarCoordinator.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 11.01.2023.
//

import UIKit

final class CalendarCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    private var modalNavigationController: UINavigationController?
    var parentCoordinator: SystatisticCoordinator?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.modalNavigationController = UINavigationController()
        let calendarController = CalendarController()
        modalNavigationController?.setViewControllers([calendarController], animated: false)
        modalNavigationController?.modalPresentationStyle = .overCurrentContext
        calendarController.delegate = parentCoordinator
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: false)
        }
    }
    
}
