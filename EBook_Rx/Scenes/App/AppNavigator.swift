//
//  AppNavigator.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/29/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit

protocol AppNavigatorType {
    func toCategory()
}

struct AppNavigator: AppNavigatorType {
    unowned let assembler: Assembler
    unowned let window: UIWindow
    
    func toCategory() {
        let nav = UINavigationController()
        let vc: CategoryViewController = assembler.resolve(navigationController: nav)
        nav.viewControllers.append(vc)

        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
}
