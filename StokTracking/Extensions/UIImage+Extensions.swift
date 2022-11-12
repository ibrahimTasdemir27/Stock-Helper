//
//  UIImage+Extensions.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 8.11.2022.
//

import UIKit

extension UIImage{
    func config(_ size : CGFloat = 24) -> UIImage.SymbolConfiguration {
        let config = UIImage.SymbolConfiguration(
            pointSize: size, weight: .regular, scale: .default)
        return config
    }
}
