//
//  BookDetailViewController.swift
//  EBook_Rx
//
//  Created by le.thi.diem.my on 5/31/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit
import Reusable
import MGArchitecture
import RxSwift
import RxCocoa
import PDFKit

class BookDetailViewController: UIViewController, Bindable {

    @IBOutlet weak var pdfView: PDFView!
    var viewModel: BookDetailViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func bindViewModel() {
        let input = BookDetailViewModel.Input(loadTrigger: Driver.just(()))
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.openBookURL
            .drive(bindOpenBookURL)
            .disposed(by: disposeBag)
    }
}

// MARK: - StoryboardSceneBased
extension BookDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}


extension BookDetailViewController {
    var bindOpenBookURL: Binder<URL> {
        return Binder(self) { (vc, bookURL) in
            vc.pdfView.document = PDFDocument(url: bookURL)
            vc.pdfView.displayMode = .singlePageContinuous
            vc.pdfView.autoScales = true
        }
    }
}
