//
//  Helper.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 8.11.2022.
//

import UIKit

enum Icons {
    case plus
    case minus
    case trash
    case shopping
    case mount
    case back
    case clock
    case calendar
    
    var image : UIImage {
        switch self {
        case .plus:                 return UIImage(systemName: "plus.circle") ?? UIImage()
        case .minus:                return UIImage(systemName: "minus.circle") ?? UIImage()
        case .trash:                return UIImage(systemName: "trash.circle") ?? UIImage()
        case .shopping:             return UIImage(systemName: "cart.circle") ?? UIImage()
        case .mount:                return UIImage(systemName: "mount") ?? UIImage()
        case .back:                 return UIImage(systemName: "arrowshape.turn.up.backward.circle") ?? UIImage()
        case .clock:                return UIImage(systemName: "clock") ?? UIImage()
        case .calendar:             return UIImage(systemName: "calendar.badge.clock") ?? UIImage()
        }
    }
}

let userDefaults = UserDefaults.standard
typealias decodeFeatures = [Features]
typealias escapeFeaturesViewModels = ([FeaturesViewModel]) -> Void

enum usDef {
    case index
    case indexBasket
    
    var indexPath: Int {
        switch self {
        case .index:                return userDefaults.integer(forKey: "index")
        case .indexBasket:          return userDefaults.integer(forKey: "indexOfBasket")
        }
    }
}

func prepareError<V: UIViewController>(vc: V, error: ShowError) {
    let alert = UIAlertController(title: error.errorText , message: error.errorSubtitle, preferredStyle: .alert)
    let okey = UIAlertAction(title: "Ok", style: .destructive)
    alert.addAction(okey)
    vc.present(alert, animated: true)
}
