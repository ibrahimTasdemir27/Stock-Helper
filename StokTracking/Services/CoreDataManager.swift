//
//  CoreDataManager.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 10.11.2022.
//

import CoreData
import UIKit

enum FieldKeyCoredata: String {
    case stocks = "Stocks"
    case image = "image"
    case texts = "texts"
    case dict = "dict"
}

final class CoreDataManager {
    static let shared = CoreDataManager()
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
    
    func save(_ vm: FeaturesModel) {
        let dictionary : [String : [Features]] = ["dict":vm.titleModel]
        
        do {
            let encodedDictionary = try JSONEncoder().encode(dictionary)
            let stocks = Stocks(context: moc)
            stocks.setValue(vm.imageName, forKey: FieldKeyCoredata.image.rawValue)
            stocks.setValue(encodedDictionary, forKey: FieldKeyCoredata.texts.rawValue)
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
    
    func update(_ index: Int, _ vm: FeaturesModel) {
        let dictionary = ["dict":vm.titleModel]
        do {
            let encodedDictionary = try JSONEncoder().encode(dictionary)
            let fetchRequest = NSFetchRequest<Stocks>(entityName: FieldKeyCoredata.stocks.rawValue)
            let stocks = try moc.fetch(fetchRequest)
            stocks[index].setValue(vm.imageName, forKey: FieldKeyCoredata.image.rawValue)
            stocks[index].setValue(encodedDictionary, forKey: FieldKeyCoredata.texts.rawValue)
            try moc.save()
        } catch {
            print(error)
        }
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
    
    func parseCoreData(completion : @escaping ([FeaturesViewModel]) -> Void) {
        let stocks = self.fetch()
        var featuresVM = [FeaturesViewModel]()
        var features = [Features]()
        featuresVM = stocks.map({ stocks in
            let data = stocks.texts
            let imageName = stocks.image
            do {
                let result = try JSONDecoder().decode([String : [Features]].self, from: data!)
                data!.forEach {_ in
                    let titlex = result.values
                    titlex.forEach { model in
                        features = model
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
            return FeaturesViewModel(featuresModel: FeaturesModel(imageName: imageName!, titleModel: features))
        })
        completion(featuresVM)
    }
}

