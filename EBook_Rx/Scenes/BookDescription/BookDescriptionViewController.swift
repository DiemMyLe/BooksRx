//
//  BookDescriptionViewController.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable

class BookDescriptionViewController: UIViewController, Bindable {
    @IBOutlet weak var imgBook: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbAuthor: UILabel!
    @IBOutlet weak var lbPages: UILabel!
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnReading: UIButton!
    
    var viewModel: BookDescriptionViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnDownload.layer.cornerRadius = 8
        btnReading.layer.cornerRadius = 8
    }
    
    func bindViewModel() {
        let input = BookDescriptionViewModel.Input(loadTrigger: Driver.just(()),
                                                   downloadTrigger: btnDownload.rx.tap.asDriver(),
                                                   readingTrigger: btnReading.rx.tap.asDriver())
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.book
            .drive(bindBookDescription)
            .disposed(by: disposeBag)
        
        output.downloadError
            .drive(bindDownloadError)
            .disposed(by: disposeBag)
        
        output.readingBook
            .drive()
            .disposed(by: disposeBag)
        
        output.isExitBook
            .drive(bindCheckBookExitLocal)
            .disposed(by: disposeBag)
    }
}

// MARK: - StoryboardSceneBased
extension BookDescriptionViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

// MARK: - Binder
extension BookDescriptionViewController {
    var bindBookDescription: Binder<Book> {
        return Binder(self) { (vc, book) in
            vc.imgBook.loadImageFromURL(urlString: book.thumbnail)
            vc.lbTitle.text = book.title
            vc.lbAuthor.text = book.author
            vc.lbPages.text = "\(book.pages) trang"
            vc.textViewDescription.text = book.description
        }
    }
    
    var bindDownloadError: Binder<String> {
        return Binder(self) { (vc, error) in
            if error.isEmpty {
                //open book ???
                vc.btnDownload.isEnabled = false
                vc.btnDownload.backgroundColor = .systemGray5
                
                vc.btnReading.isEnabled = true
                vc.btnReading.backgroundColor = .systemGreen
                
            } else {
                let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                vc.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    var bindCheckBookExitLocal: Binder<Bool> {
        return Binder(self) { (vc, status) in
            vc.btnDownload.isEnabled = !status
            vc.btnDownload.backgroundColor = status ? .systemGray5 : AppColor.orageColor
            
            vc.btnReading.isEnabled = status
            vc.btnReading.backgroundColor = status ? AppColor.greenColor : .systemGray5
        }
    }
    
}
