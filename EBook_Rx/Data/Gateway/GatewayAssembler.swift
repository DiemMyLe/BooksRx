//
//  GatewayAssembler.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit

protocol GatewayAssembler {
    func resolve() -> DataBooksGatewayType
}

extension GatewayAssembler where Self: DefaultAssembler {
    func resolve() -> DataBooksGatewayType {
        return DataBooksGateway()
    }
}
