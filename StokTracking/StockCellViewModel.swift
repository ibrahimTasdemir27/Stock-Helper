//
//  StockCellViewModel.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 10.11.2022.
//

import Foundation

final class StockCellViewModel {
    
    private let stocks : Stocks
    private var model : [TitleModel]?
    
    init(stocks: Stocks) {
        self.stocks = stocks
    }
    
    var dataTexts : [TitleModel] {
        guard let data = stocks.texts else {return []}
        do {
            let jsonDecoded = try JSONSerialization.jsonObject(with: data)
            if jsonDecoded is [String : Any] {
                let data = try JSONDecoder().decode([String : [TitleModel]].self, from: jsonDecoded as! Data)
                data.forEach {_ in
                    let titlex = data.values
                    titlex.forEach { model in
                        self.model = model
                        print(model[0].title)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return model ?? []
    }
    
    var imageString : String? {
        stocks.image
    }
}
