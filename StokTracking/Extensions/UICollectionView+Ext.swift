//
//  UICollectionView+Ext.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 16.01.2023.
//

import UIKit.UICollectionView

extension UICollectionView {
    func register(_ type: UICollectionViewCell.Type) {
        let typeName = String(describing: type)
        self.register(type, forCellWithReuseIdentifier: typeName)
    }
    
    
}
