//
//  BasketChildViewModel.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 20.12.2022.
//

import Foundation


final class ShoppingChildViewModel {
    
    weak var coordinator: ShoppingCoordinator?
    var coreDataManager: CoreDataManager = .shared
    var cartModels = [CartModel]()
    
    var delegate: DidShowListDelegate?
    
    init() {
        getCart()
    }
    
    func getCart() {
        coreDataManager.parseStocks { featuresViewModels in
            featuresViewModels.forEach { featuresvm in
                let image = featuresvm.imageName
                let titleModel = featuresvm.titleModel.prefix(3)
                let name = titleModel.first!.overview
                let price = Double(titleModel[1].overview)!
                let cartModel = CartModel(image: image, name: name, price: price, quantity: 1)
                self.cartModels.append(cartModel)
            }
        }
    }
    
    func numberOfRows() -> Int {
        return self.cartModels.count
    }
    
    func modalAt(_ index: Int) -> String {
        return self.cartModels[index].name
    }
    
    func selectRow(_ index: Int) {
        if let delegate = self.delegate {
            delegate.selectProduct(vm: cartModels[index])
        }
    }
    
    
    
    deinit {
        print("I'm deinit: BasketChildViewModel")
    }
}
