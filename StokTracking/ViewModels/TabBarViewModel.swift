//
//  HomePageViewModel.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 6.11.2022.
//

import Foundation

final class TabBarViewModel {
    
    var coordinator : AppCoordinator?
    
    func viewWillAppear() {
        coordinator?.viewWillAppear()
    }
    
    
}
