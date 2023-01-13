//
//  CustomizeAppearance.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 10.12.2022.
//

import UIKit

protocol CustomizeAppearance {
    static func customizeAppearance()
}

extension UIApplication: CustomizeAppearance {
    static func customizeAppearance() {
        UINavigationBar.customizeAppearance()
        UIBarButtonItem.customizeAppearance()
        UITableView.customizeAppearance()
        UICollectionView.customizeAppearance()
        UITabBarAppearance.customizeAppearance()
        UITabBar.customizeAppearance()
        
    }
}

extension UINavigationBar: CustomizeAppearance {
    static func customizeAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .primaryColor
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        appearance().standardAppearance = navigationBarAppearance
        appearance().compactAppearance = navigationBarAppearance
        appearance().scrollEdgeAppearance = navigationBarAppearance
    }
}


extension UIBarButtonItem: CustomizeAppearance {
    static func customizeAppearance() {
        appearance().tintColor = .white
    }
}

extension UITabBarAppearance: CustomizeAppearance {
    static func customizeAppearance() {
        UITabBarAppearance().backgroundEffect = nil
        UITabBarAppearance().backgroundColor = .systemGray6
        
    }
    
    func makeScrollAppearance() -> UITabBarAppearance {
        return self
    }
}

extension UITabBar: CustomizeAppearance {
    static func customizeAppearance() {
        appearance().backgroundColor = .systemGray6
        appearance().barTintColor = .systemGray6
        appearance().tintColor = .secondaryColor
        appearance().scrollEdgeAppearance = UITabBarAppearance().makeScrollAppearance()
    }
}

extension UITableView: CustomizeAppearance {
    static func customizeAppearance() {
        appearance().separatorStyle = .none
        appearance().backgroundColor = .systemGray6
    }
}

extension UICollectionView: CustomizeAppearance {
    static func customizeAppearance() {
        appearance().backgroundColor = .clear
        appearance().translatesAutoresizingMaskIntoConstraints = false
        appearance().showsHorizontalScrollIndicator = false
    }
}
