//
//  CategoryUseCase.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol CategoryUseCaseType {
    func getListCategories(fileName: String) -> Observable<[Category]>
    func deleteAllBooks() -> Observable<Bool>
}

struct CategoryUseCase: CategoryUseCaseType, GetCategoriesList {
    var dataBooksGateway: DataBooksGatewayType
    
    func getListCategories(fileName: String) -> Observable<[Category]> {
        return getCategories(fileName: fileName)
    }
    
    func deleteAllBooks() -> Observable<Bool> {
        return deleteAllBookLocal()
    }
}

