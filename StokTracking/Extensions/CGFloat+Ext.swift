//
//  CGFloat+Ext.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 8.01.2023.
//

import Foundation


extension CGFloat {
    func formatAsPercent() -> String {
        return String(format: "%.1f", self * 100)
    }
}
