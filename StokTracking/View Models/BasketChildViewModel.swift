//
//  BasketChildViewModel.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 20.12.2022.
//

import Foundation


final class BasketChildViewModel {
    
    weak var coordinator: BasketCoordinator?
    var coreDataManager: CoreDataManager = .shared
    var basketModels = [BasketModel]()
    
    var delegate: DidShowListDelegate?
    
    init() {
        getBasket()
    }
    
    func getBasket() {
        coreDataManager.parseStocks { featuresViewModels in
            featuresViewModels.forEach { featuresvm in
                let image = featuresvm.imageName
                let titleModel = featuresvm.titleModel.prefix(3)
                let name = titleModel.first!.overview
                let price = Double(titleModel[1].overview)!
                let basketModel = BasketModel(image: image, name: name, price: price, quantity: 1)
                self.basketModels.append(basketModel)
            }
        }
    }
    
    func numberOfRows() -> Int {
        return self.basketModels.count
    }
    
    func modalAt(_ index: Int) -> String {
        return self.basketModels[index].name
    }
    
    func selectRow(_ index: Int) {
        if let delegate = self.delegate {
            delegate.selectProduct(vm: basketModels[index])
        }
    }
    
    
    
    deinit {
        print("I'm deinit: BasketChildViewModel")
    }
}
