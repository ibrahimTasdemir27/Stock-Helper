//
//  AddProductViewModel.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 9.11.2022.
//

import Foundation

final class AddProductViewModel {
    
    private var titleCellViewModel : TitleModel?
    private var overviewCellViewModel : TitleModel?
    private var imageCellViewModel : TitleModel?
    
    enum AddCell {
        case title([TitleModel])
    }
    
    var coordinator : AddProductCoordinator?
    
    var addingcell : [AddCell] = []
    
    
    var onUpdate = {}
    
    func setupProductCell() {
        addingcell = [
            .title([
                TitleModel(title: "Ürün Adı", overview: ""),
                TitleModel(title: "Ürün Fiyatı", overview: ""),
                TitleModel(title: "S.K.T", overview: "")
            ])
        ]
        onUpdate()
    }
    
    func viewDidLoad() {
        setupProductCell()
    }
    
    func viewDidDisappear() {
        coordinator?.didFinish()
    }
    
    func tappedAddCell() {
        switch addingcell.first {
        case .title(var titleModel):
            titleModel.append(TitleModel(title: " ", overview: " "))
            addingcell = [
                .title(titleModel)
            ]
        case .none:
            break
        }
        onUpdate()
    }
    
    func tappedDone(image : String) {
        switch addingcell.first {
        case .title(let titleModel):
            var dictionary : [String : [TitleModel]] = [:]
            dictionary["dict"] = titleModel
            do {
                let encodedDictionary = try JSONEncoder().encode(dictionary)
                CoreDataManager.shared.save(image: image, data: encodedDictionary)
            } catch {
                print("error: ", error)
            }
        case .none:
            break
        }
        coordinator?.didFinishSaveProduct()
    }
    
    func cellUpdateTextField(_ indexPath : IndexPath , _ text : String) {
        switch addingcell[0] {
        case .title(let titleModel):
            titleModel[indexPath.row].updateTitle(text)
        }
    }
    
    func cellUpdateTextView(_ indexPath : IndexPath , _ text : String) {
        switch addingcell[0] {
        case .title(let titleModel):
            titleModel[indexPath.row].updateOverview(text)
        }
    }
    
}
