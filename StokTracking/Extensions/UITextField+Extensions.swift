//
//  UITextField+Extensions.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 9.11.2022.
//

import UIKit

extension UITextField {
    
    func staticPadding(leftPadding : Int = 0 , rightPadding : Int = 0) {
        guard self.text != nil else {
            return
        }
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: Int(self.frame.size.height)))
        self.leftViewMode = .always
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: Int(self.frame.size.height)))
        self.rightViewMode = .always
    }
}
