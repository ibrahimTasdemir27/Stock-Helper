//
//  UIView+Extensions.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 29.11.2022.
//

import UIKit

extension UIView {
    func bounce() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }, completion: { finished in
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
        })
    }
}
