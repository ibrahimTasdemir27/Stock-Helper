//
//  BasketViewModel.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 17.12.2022.
//

import Foundation


final class BasketViewModel {
    
    let title = "Sepetim"
    
    weak var coordinator: BasketCoordinator?
    var coreDataManager: CoreDataManager = .shared
    
    var basketModels = [BasketModel]()
    
    var onUpdate = {}
    
    var readPrice = {}
    
    lazy var dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .gmt
        dateFormatter.dateFormat = "dd.MM.yyy"
        return dateFormatter
    }()
    
    
    func numberOfRows() -> Int {
        return self.basketModels.count + 1
    }
    
    func showList(_ index: Int) {
        coordinator?.prepareChild(index)
    }
    
    func updateBasket(_ vm: BasketModel) {
        if basketModels.count == selectedIndex {
            self.basketModels.append(vm)
        } else {
            self.basketModels[selectedIndex] = vm
        }
        onUpdate()
        readPrice()
    }
    
    func updatePrice(_ index: Int, _ vm: BasketModel) {
        self.basketModels[index] = vm
    }
    
    func updateDate() {
        for i in .zero...basketModels.count - 1 {
            let date = Date.getGmt(from: .gmt)
//            let newDate = date.addingTimeInterval(TimeInterval(60*60*24*10))
//            print("isNewDate",newDate)
            basketModels[i].date = date
        }
    }
    
    func tappedSell() {
        updateDate()
        coreDataManager.isSell(self.basketModels)
        self.basketModels.forEach { basketModel in
            sellUpdate(vm: basketModel)
        }
        coordinator?.didFinish()
    }
    
    func sellUpdate(vm: BasketModel) {
        coreDataManager.parseStocks { featuresViewModels in
            for i in .zero...featuresViewModels.count - 1 {
                var featureViewModel = featuresViewModels[i]
                let titleModel = featureViewModel.titleModel.prefix(3)
                if titleModel.first?.overview == vm.name {
                    userDefaults.setValue(i, forKey: "index")
                    if let quantity = Double(titleModel[2].overview) {
                        featureViewModel.featuresModel.titleModel[2].overview = self.updateQuantity(quantity, vm.quantity).description
                        self.coreDataManager.update(featureViewModel.featuresModel)
                    }
                }
            }
        }
    }

    func updateQuantity(_ quantity: Double, _ quantitySold: Double) -> Double {
        if quantity - quantitySold < 0 {
            return 0
        }
        return quantity - quantitySold
    }
    
    var totalBasket: Double {
        basketModels.reduce(.zero) { value,vm in
            return value + vm.price * vm.quantity
        }
    }
    
    var selectedIndex: Int {
        get {
            var value = 0
            let userDefaults = UserDefaults.standard
            if let index = userDefaults.value(forKey: "indexOfBasket") as? Int {
                value = index
            }
            return value
        }
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: "indexOfBasket")
        }
    }
    
    func modalAt(_ index: Int) -> BasketModel? {
        if index == basketModels.count {
            return BasketModel(image: "", name: "", price: 0, quantity: 1)
        }
        return basketModels[index]
    }
    
    func viewDidDisappear() {
        coordinator?.viewDidDisappear()
    }
    
    deinit {
        print("I'm deinit: BasketViewModel")
    }
}

struct BasketModel: Codable {
    let image: String
    let name: String
    var price: Double
    var quantity: Double
    var date: Date?
    
    init(image: String, name: String, price: Double, quantity: Double) {
        self.image = image
        self.name = name
        self.price = price
        self.quantity = quantity
    }
    
    mutating func updateQuantity(quantity: String) {
        self.quantity = Double(quantity)!
    }
}
