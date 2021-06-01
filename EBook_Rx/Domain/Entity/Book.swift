//
//  Book.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//
import ObjectMapper
import Then

struct Book {
    var id = 0
    var title = ""
    var author = ""
    var description = ""
    var pages = ""
    var pdf_url = ""
    var thumbnail = ""
}

extension Book: Then, Equatable { }

extension Book: Mappable {
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        author <- map["author"]
        description <- map["description"]
        pages <- map["pages"]
        pdf_url <- map["pdf_url"]
        thumbnail <- map["thumbnail"]
    }
}
