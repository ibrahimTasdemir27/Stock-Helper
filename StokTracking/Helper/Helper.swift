//
//  Helper.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 8.11.2022.
//

import UIKit

enum Icons {
    case plus
    case trash
    case shopping
    case mount
    
    var image : UIImage {
        switch self {
        case .plus:                 return UIImage(systemName: "plus.circle") ?? UIImage()
        case .trash:                return UIImage(systemName: "trash.circle") ?? UIImage()
        case .shopping:             return UIImage(systemName: "cart.circle") ?? UIImage()
        case .mount:                return UIImage(systemName: "mount") ?? UIImage()
        }
    }
}

let userDefaults = UserDefaults.standard

enum usDef {
    case index
    
    var indexPath: Int {
        switch self {
        case .index: return userDefaults.integer(forKey: "index")
        }
    }
}

func prepareError<V: UIViewController>(vc: V, error: ShowError) {
    let alert = UIAlertController(title: error.errorText , message: error.errorSubtitle, preferredStyle: .actionSheet)
    let okey = UIAlertAction(title: "Ok", style: .destructive)
    alert.addAction(okey)
    vc.present(alert, animated: true)
}
