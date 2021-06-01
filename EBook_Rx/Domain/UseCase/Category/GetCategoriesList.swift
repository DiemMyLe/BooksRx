//
//  GetCategoriesList.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit
import RxSwift
import MGArchitecture

protocol GetCategoriesList {
    var dataBooksGateway: DataBooksGatewayType { get }
}

extension GetCategoriesList {
    func getCategories(fileName: String) -> Observable<[Category]> {
        return dataBooksGateway.getCategoriesJson(fileName: fileName)
    }
    
    func deleteAllBookLocal() -> Observable<Bool> {
        return dataBooksGateway.deleteAllBookLocal()
    }
}
