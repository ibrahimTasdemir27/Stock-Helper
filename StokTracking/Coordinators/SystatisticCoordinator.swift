//
//  SystatisticCoordinator.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 1.01.2023.
//

import UIKit

protocol DidSelectDateDelegate {
    func selectedDate(_ date: Date)
}

final class SystatisticCoordinator: Coordinator, DidSelectDateDelegate {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: HomeCoordinator?
    var delegate: DidSelectDateDelegate?
    
    private let navigationController: UINavigationController
    private var modalNavigationController: UINavigationController?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let systatisticVC = SystatiscticViewController()
        let systatisticVM = SystatisticViewModel()
        systatisticVM.coordinator = self
        systatisticVC.systatisticVM = systatisticVM
        delegate = systatisticVM
        self.modalNavigationController = UINavigationController()
        self.modalNavigationController?.modalPresentationStyle = .fullScreen
        modalNavigationController?.setViewControllers([systatisticVC], animated: false)
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: true)
        }
    }
    
    func didFinish() {
        navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
    
    func tappedCalendar() {
        let calendarCoordinator = CalendarCoordinator(modalNavigationController!)
        calendarCoordinator.parentCoordinator = self
        childCoordinators.append(calendarCoordinator)
        calendarCoordinator.start()
    }
    
    func selectedDate(_ date: Date) {
        delegate?.selectedDate(date)
        modalNavigationController?.dismiss(animated: false)
    }
    
    deinit {
        print("I'm deinit: Systatistic Coordinator")
    }
}
