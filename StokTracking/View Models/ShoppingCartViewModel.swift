//
//  BasketViewModel.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 17.12.2022.
//

import Foundation


final class ShoppingCartViewModel {
    
    let title = "Sepetim"
    
    weak var coordinator: ShoppingCoordinator?
    var coreDataManager: CoreDataManager = .shared
    
    var cartModels = [CartModel]() {
        didSet {
            
        }
    }
    
    var onUpdate = {}
    
    var readPrice = {}
    
    lazy var dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .gmt
        dateFormatter.dateFormat = "dd.MM.yyy"
        return dateFormatter
    }()
    
    
    func numberOfRows() -> Int {
        return self.cartModels.count + 1
    }
    
    func showList(_ index: Int) {
        coordinator?.prepareChild(index)
    }
    
    func updateCart(_ vm: CartModel) {
        if cartModels.count == selectedIndex {
            print("Append")
            self.cartModels.append(vm)
        } else {
            print("Update")
            self.cartModels[selectedIndex] = vm
        }
        onUpdate()
        readPrice()
    }
    
    func updatePrice(_ index: Int, _ vm: CartModel) {
        if index != cartModels.count { cartModels[index] = vm }
        readPrice()
    }
    
    func updateDate() {
        for i in .zero...cartModels.count - 1 {
            let date = Date.getGmt(from: .gmt)
//            let newDate = date.addingTimeInterval(TimeInterval(60*60*24*10))
//            print("isNewDate",newDate)
            cartModels[i].date = date
        }
    }
    
    func tappedSell() {
        updateDate()
        coreDataManager.isSell(self.cartModels)
        self.cartModels.forEach { cartModel in
            sellUpdate(vm: cartModel)
        }
        coordinator?.didFinish()
    }
    
    func sellUpdate(vm: CartModel) {
        coreDataManager.parseStocks { featuresViewModels in
            for i in .zero..<featuresViewModels.count {
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
    
    var totalCart: Double {
        cartModels.reduce(.zero) { value,vm in
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
    
    func modalAt(_ index: Int) -> CartModel? {
        if index == cartModels.count {
            return CartModel(image: "", name: "", price: 0, quantity: 1)
        }
        return cartModels[index]
    }
    
    func viewDidDisappear() {
        coordinator?.viewDidDisappear()
    }
    
    deinit {
        print("I'm deinit: BasketViewModel")
    }
}

struct CartModel: Codable {
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
    
    mutating func updateQuantity(_ quantity: Double) {
        self.quantity = quantity
    }
    
    mutating func updatePrice(_ price: Double) {
        self.price = price
    }
}
