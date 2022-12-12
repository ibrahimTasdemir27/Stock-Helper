//
//  UIViewController+Ext.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 10.12.2022.
//

import UIKit.UIViewController

extension UIViewController {
    
    var statusBarNavigationHeight: CGFloat {
        var height: CGFloat = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? UIApplication.shared.statusBarFrame.height
        guard  let navigationHeight = self.navigationController?.navigationBar.bounds.height else { return height}
            height += navigationHeight
        return height
    }
}

