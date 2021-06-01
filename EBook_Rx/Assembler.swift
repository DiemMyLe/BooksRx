//
//  Assembler.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/29/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

protocol Assembler: class,
                    AppAssembler,
                    CategoryAssembler,
                    BookListAssembler,
                    BookDescriptionAssembler,
                    BookDetailAssembler,
                    GatewayAssembler {
    
}

final class DefaultAssembler: Assembler {
    
}
