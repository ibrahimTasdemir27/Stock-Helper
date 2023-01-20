//
//  CoreDataManager.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 10.11.2022.
//

import CoreData


enum FieldKeyCoredata: String {
    case stocks = "Stocks"
    case image = "image"
    case texts = "texts"
    case dict = "dict"
}

enum ShowError: Error {
    case emptyFeatures
    case alreadyName
    case isNotNumber
    
    var errorText: String  {
        switch self {
        case .emptyFeatures:         return "Boş olan kutucuklar var"
            
        case .alreadyName:           return "Bu isimde bir ürün zaten var"
            
        case .isNotNumber:           return "Ürün fiyatı ve Ürün adedi sayılardan oluşmalıdır"
            
        }
    }
    
    var errorSubtitle: String {
        switch self {
        case .emptyFeatures:         return "Lütfen boş alanları doldurun"
        case .alreadyName:           return "Lütfen farklı bir isim giriniz"
        case .isNotNumber:           return "Lütfen sayı olacak şekilde yeniden giriniz"
        }
    }
}

enum CoreAction {
    case editing
    case selling
}


final class CoreDataManager {
    static let shared = CoreDataManager()
    var action: CoreAction
    
    
    init(_ action: CoreAction = CoreAction.editing) {
        self.action = action
    }
    
    
    lazy var persistentContainer : NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "StokTracking")
        persistentContainer.loadPersistentStores { _, error in
            print(error?.localizedDescription ?? "")
        }
        return persistentContainer
    }()
    
    var moc : NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var stocks: [Stocks] {
        self.fetch()
    }
    
    var soldItem: [Selling] {
        self.fetchSold()
    }
    
    func save(_ vm: FeaturesModel) {
        do {
            let encodeArray = try JSONEncoder().encode(vm.titleModel)
            let stocks = Stocks(context: moc)
            stocks.setValue(vm.imageName, forKey: FieldKeyCoredata.image.rawValue)
            stocks.setValue(encodeArray, forKey: FieldKeyCoredata.texts.rawValue)
            try moc.save()
        } catch {
            print("error: ", error)
        }
    }
    
    func fetch() -> [Stocks] {
        do {
            let fetchRequest = NSFetchRequest<Stocks>(entityName: FieldKeyCoredata.stocks.rawValue)
            let stocks = try moc.fetch(fetchRequest)
            return stocks
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func update(_ vm: FeaturesModel) {
        let indexPa = usDef.index.indexPath
        do {
            let encodedArray = try JSONEncoder().encode(vm.titleModel)
            let fetchRequest = NSFetchRequest<Stocks>(entityName: FieldKeyCoredata.stocks.rawValue)
            let stocks = try moc.fetch(fetchRequest)
            stocks[indexPa].setValue(vm.imageName, forKey: FieldKeyCoredata.image.rawValue)
            stocks[indexPa].setValue(encodedArray, forKey: FieldKeyCoredata.texts.rawValue)
            try moc.save()
        } catch {
            print(error)
        }
    }
    
    func fetchSold() -> [Selling] {
        do {
            let fetchRequest = NSFetchRequest<Selling>(entityName: "Selling")
            let soldItem = try moc.fetch(fetchRequest)
            return soldItem
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func isSell(_ vm: [CartModel]) {
//        let totalPrice = vm.reduce(0) { partialResult, model in
//            return partialResult + model.quantity * model.price
//        }
//        let filteredName = vm.map { model in
//            return model.name
//        }
//        let filterName = vm.reduce(into: []) { (partialResult: inout [String] , model) in
//            partialResult.append(model.name)
//        }
        do {
            let decodeModel = try JSONEncoder().encode(vm)
            let selling = Selling(context: moc)
            selling.setValue(decodeModel, forKey: "soldItem")
            try moc.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func isContains(text: String) -> Bool {
        var contains = false
        if let title = userDefaults.value(forKey: "title") as? String {
            if title == text {
                contains = false
            } else {
                parseStocks { featuresViewModel in
                    featuresViewModel.forEach { features in
                        if features.titleModel.first!.overview == text {
                            contains = true
                        }
                    }
                }
            }
        }
        return contains
    }
    
    func deleteAll() {
        do {
            let fetchRequest = NSFetchRequest<Stocks>(entityName: FieldKeyCoredata.stocks.rawValue)
            let stocks = try moc.fetch(fetchRequest)
            try stocks.forEach {
                moc.delete($0)
                try moc.save()
                print("Siliniyor...")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(indexPath : Int) {
        do {
            let fetchRequest = NSFetchRequest<Stocks>(entityName: FieldKeyCoredata.stocks.rawValue)
            let stocks = try moc.fetch(fetchRequest)
            moc.delete(stocks[indexPath])
            try moc.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func parseStocks(completion : @escaping (escapeFeaturesViewModels)) {
        let featuresViewModels = stocks.reduce(into: []) { (partialResult: inout [FeaturesViewModel], stock) in
            guard let data = stock.texts, let imageName = stock.image else { return }
            do {
                let result = try JSONDecoder().decode(decodeFeatures.self, from: data)
                partialResult.append(FeaturesViewModel(featuresModel: FeaturesModel(imageName: imageName, titleModel: result)))
            } catch {
                print(error.localizedDescription)
            }
        }
        completion(featuresViewModels)
    }
    
    
    func parseSold(completion: @escaping([CartModel]) -> Void) {
        let cartModels = soldItem.reduce(into: []) { (partialResult: inout [CartModel], model) in
            guard let data = model.soldItem else { return }
            do {
                let result = try JSONDecoder().decode([CartModel].self, from: data)
                partialResult.append(contentsOf: result)
            } catch {
                print("parsError",error)
            }
        }
        completion(cartModels)
    }
    
    
}



