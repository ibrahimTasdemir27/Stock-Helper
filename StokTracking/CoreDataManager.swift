//
//  CoreDataManager.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 10.11.2022.
//

import CoreData
import UIKit


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
    
    func save(image : String , data : Data) {
        let stocks = Stocks(context: moc)
        stocks.setValue(image, forKey: "image")
        stocks.setValue(data, forKey: "texts")
        
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetch() -> [Stocks] {
        do {
            let fetchRequest = NSFetchRequest<Stocks>(entityName: "Stocks")
            let stocks = try moc.fetch(fetchRequest)
            return stocks
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func delete(indexPath : Int) {
        do {
            let fetchRequest = NSFetchRequest<Stocks>(entityName: "Stocks")
            let stocks = try moc.fetch(fetchRequest)
            try stocks.forEach {
                if stocks[indexPath] === $0 {
                    moc.delete($0)
                    try moc.save()
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
