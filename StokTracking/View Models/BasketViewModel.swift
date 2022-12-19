//
//  BasketViewModel.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 17.12.2022.
//

import Foundation


final class BasketViewModel {
    
    let title = "Sepetim"
    
    private let coreDataManager: CoreDataManager = .shared
    
    var numberOfRows = 3
    
    var featuresViewModel = [FeaturesViewModel]()
    
    var features = [String]()
    
    init(){
        getFeatures()
    }
    
    func getFeatures() {
        coreDataManager.parseCoreData { featuresViewModels in
            self.featuresViewModel = featuresViewModels
            featuresViewModels.forEach { featuresViewModel in
                self.features.append(featuresViewModel.titleModel.first!.overview)
            }
        }
    }
    
    func numberOfRowsFeatures() -> Int {
        return self.features.count
    }
    
    func modalAtFeatures(_ index: Int) -> String {
        return self.features[index]
    }
    
    func modalAt(_ index: Int) -> BasketModel? {
        let titleModel = featuresViewModel[index].titleModel
        let name = titleModel[0].overview
        let price = titleModel[1].overview
        let quantity = titleModel[2].overview
        if index == numberOfRows - 1 {
            return BasketModel(name: "", price: "", quantity: "")
        }
        return BasketModel(name: name, price: price, quantity: quantity)
    }
}

struct BasketModel {
    let name: String
    let price: String
    var quantity: String
    
    mutating func updateQuantity(quantity: Int) {
        
    }
}
