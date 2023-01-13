//
//  String+Ext.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 18.12.2022.
//

import Foundation

extension String {
    func isNotEmpty() -> Bool {
        if self.isEmpty { return false } else {
            var iterator = self.makeIterator()
            while let text = iterator.next() {
                if text != " " { return true }
            }
        }
       
//        var empty = false
//        self.forEach {
//            if $0 != " " {
//                empty = true
//            }
//        }
//
        //return empty
        return false
    }
}
