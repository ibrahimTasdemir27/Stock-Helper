//
//  Double+Ext.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 19.01.2023.
//

import Foundation


extension Double {
    func isPositive() -> Bool {
        return self >= Double.zero ? true : false
    }
}
