//
//  HomePageCellViewModel.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 7.11.2022.
//

import UIKit


final class HomePageCellViewModel {
    
    var coordinator : HomeCoordinator?
    var coreDataManager : CoreDataManager
    
    init(coreDataManager : CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }
    
    enum SuperTitleCell {
        case imageAndText(TitleViewModel)
    }
    
    var titleModel : [TitleModel] = []
    
    var onUpdate = {}
    
    var superTitleCells : [HomePageCellViewModel.SuperTitleCell] = []
    
    func reload() {
        let stocks = coreDataManager.fetch()
        superTitleCells = stocks.map({
            let _: () = parseCoreData(data: $0.texts!) {
                self.titleModel = $0
            }
            return .imageAndText(TitleViewModel(imageName: $0.image ?? "medicine1", titleModel: self.titleModel))
            
        })
        onUpdate()
    }
    
    func parseCoreData(data : Data ,completion : @escaping ([TitleModel]) -> Void) {
        do {
                let data = try JSONDecoder().decode([String : [TitleModel]].self, from: data)
                data.forEach {_ in
                    let titlex = data.values
                    titlex.forEach { model in
                        completion(model)
                    }
                }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func numberOfRows() -> Int {
        return superTitleCells.count
    }
    
    func viewDidLoad() {
        reload()
    }
    
    func selectedItem(_ indexPath : Int) {
        coordinator?.selectItem(indexPath)
    }
    
    func tappedAdd() {
        coordinator?.startAddProduct()
    }
    
}
