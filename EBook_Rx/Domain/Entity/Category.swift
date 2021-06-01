//
//  Category.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//
import ObjectMapper
import Then

struct Category {
    var id = ""
    var title = ""
    var books = [Book]()
}

extension Category: Then, Equatable { }

extension Category: Mappable {
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        books <- map["books"]
    }
}


///categories

struct Categories {
    var arrCategories = [Category]()
}

extension Categories: Then, Equatable { }

extension Categories: Mappable {
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        arrCategories <- map["categories"]
    }
}
