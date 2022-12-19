//
//  HomePageCellViewModel.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 7.11.2022.
//

import UIKit


final class FeaturesListViewModel {
    var title = "Ürünlerim"
    var coordinator : HomeCoordinator?
    var coreDataManager : CoreDataManager? = CoreDataManager.shared

//    init(coreDataManager : CoreDataManager = .shared) {
//        self.coreDataManager = coreDataManager
//    }
    
    var onUpdate = {}
    
    
    var featuresVM = [FeaturesViewModel]()
    
    func numberOfSection() -> Int {
        return featuresVM.count
    }
    
    func imageName(_ index: Int) -> String {
        return featuresVM[index].imageName
    }
    
    func modalAt(_ index: Int) -> FeaturesModel {
        return featuresVM[index].featuresModel
    }
    
    func modelAt(_ section: Int, _ indexPath: Int) -> Features {
        return featuresVM[section].titleModel[indexPath]
    }
    
    func reload() {
        DispatchQueue.main.async { [self] in
            coreDataManager?.parseCoreData { [weak self] featureListModel in
                self?.featuresVM = featureListModel
                self?.onUpdate()
            }
        }
    }
    
    func removeItem(indexPath : Int) {
        coreDataManager?.delete(indexPath: indexPath)
        reload()
    }
    
    func didSaveProduct(vm: FeaturesModel) {
        coreDataManager?.save(vm)
    }
    
    func viewDidLoad() {
        coordinator?.updater = reload
        reload()
    }
    
    func tappedBasket() {
        coordinator?.tappedBasket()
    }
    
    func selectedItem(_ indexPath : Int) {
        coordinator?.selectItem(indexPath)
    }
    
    func tappedAdd() {
        coordinator?.startAddProduct()
    }
    
    var selectedIndex: Int {
        get {
            var value = 0
            let userDefaults = UserDefaults.standard
            if let index = userDefaults.value(forKey: "index") as? Int {
                value = index
            }
            return value
        }
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: "index")
        }
    }
}

struct FeaturesViewModel {
    let featuresModel: FeaturesModel
    var titleModel: [Features]
    
    init(featuresModel: FeaturesModel) {
        self.featuresModel = featuresModel
        self.titleModel = featuresModel.titleModel
    }
    
    var imageName: String {
        return featuresModel.imageName
    }
}
