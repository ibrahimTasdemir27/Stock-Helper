//
//  String+Ext.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 18.12.2022.
//

import Foundation

extension String {
    func isNotEmpty() -> Bool {
        var empty = false
        self.forEach {
            if $0 != " " {
                empty = true
            }
        }
        if self.isEmpty {
            empty = false
        }
        return empty
    }
}
