//
//  SettingsViewModel.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 10.12.2022.
//

import Foundation

class SettingsViewModel {
    
    let title = "Ayarlar"
    
    var coordinator: HomeCoordinator?
    
    var settings = ["Gece Modu","İstatistikler","Uygulamayı Paylaş","Çıkış Yap"]
    
    func numberOfRows() -> Int {
        return settings.count
    }
    
    func modalAt(_ index: Int) -> String {
        return settings[index]
    }
    
    func didSelect(_ index: Int) {
        switch index {
        case 1:
            coordinator?.didSelectSystatistic()
        default:
            print("Defaul")
        }
    }
}
