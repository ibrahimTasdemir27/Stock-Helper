//
//  TitleViewModel.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 7.11.2022.
//

import Foundation


struct FeaturesModel {
    let imageName : String
    var titleModel : [Features]
}

struct Features : Codable {
    var title : String
    var overview : String
    
    init(title: String, overview: String) {
        self.title = title
        self.overview = overview
    }
    
    mutating func updateTitle(_ text : String) {
        self.title = text
    }
    
    mutating func updateOverview(_ text : String) {
        self.overview = text
    }
}


