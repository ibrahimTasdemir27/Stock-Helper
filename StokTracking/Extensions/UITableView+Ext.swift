//
//  UITableView+Ext.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 10.12.2022.
//

import UIKit.UITableView


extension UITableView {
    
    func register(_ type: UITableViewCell.Type) {
        let typneName = String(describing: type)
        self.register(type, forCellReuseIdentifier: typneName)
    }
}

