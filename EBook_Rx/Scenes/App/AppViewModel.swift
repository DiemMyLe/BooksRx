//
//  AppViewModel.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/29/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import MGArchitecture
import RxSwift
import RxCocoa

struct AppViewModel {
    let navigator: AppNavigatorType
    let useCase: AppUseCaseType
}

extension AppViewModel: ViewModel {
    struct Input {
        let load: Driver<Void>
    }
    
    struct Output {
        
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
//        input.load
////            .flatMapLatest {
////                self.useCase.addUserData()
////                    .asDriverOnErrorJustComplete()
////            }
//            .drive(onNext: self.navigator.toCategory())
//            .disposed(by: disposeBag)
        
        input.load.drive(onNext: { (_) in
            self.navigator.toCategory()
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
