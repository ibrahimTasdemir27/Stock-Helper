//
//  Helper.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 8.11.2022.
//

import UIKit

enum Icons {
    case plus
    
    var imageName : UIImage {
        switch self {
        case .plus:                 return UIImage(systemName: "plus.circle") ?? UIImage()
        }
    }
}

let userDefaults = UserDefaults.standard
