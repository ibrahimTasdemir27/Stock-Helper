//
//  TitleViewModel.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 7.11.2022.
//


struct FeaturesModel {
    let imageName : String
    var titleModel : [Features]
}

final class Features : Codable {
    var title : String
    var overview : String
    
    init(title: String, overview: String) {
        self.title = title
        self.overview = overview
    }
    
    func updateTitle(_ text : String) {
        self.title = text
    }
    
    func updateOverview(_ text : String) {
        self.overview = text
    }
}


