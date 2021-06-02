//
//  BooksOfflineViewController.swift
//  EBook_Rx
//
//  Created by le.thi.diem.my on 6/1/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//
import UIKit
import Reusable
import MGArchitecture
import RxSwift
import RxCocoa

class BooksOfflineViewController: UIViewController, Bindable {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: BooksOfflineViewModel!
    var listBooksOffline = [BookItem]()
    var disposeBag = DisposeBag()
    var deleteBookTrigger = PublishSubject<IndexPath>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(cellType: BooksOfflineCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = AppColor.greenBackground
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    func bindViewModel() {
        let input = BooksOfflineViewModel.Input(loadTrigger: Driver.just(()),
                                                deleteBookTrigger: deleteBookTrigger.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        //get cell
        
        output.listBooksOffline
            .drive(bindListBooksOffline)
            .disposed(by: disposeBag)
        
        //delete book
        output.isDeleteBook
            .drive(bindDeleteBook)
            .disposed(by: disposeBag)
        
//        let cell = tableView.rx.modelSelected(BooksOfflineCell.self)
//        cell.subscribe { (bookCell) in
//
//        } onError: { (<#Error#>) in
//            <#code#>
//        } onCompleted: {
//            <#code#>
//        } onDisposed: {
//
//        }
    }
    
}

extension BooksOfflineViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listBooksOffline.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BooksOfflineCell.self)
        cell.setUpCell(bookItem: listBooksOffline[indexPath.row])
//        cell.deleteBookAction = {
//            self.deleteBookTrigger.onNext(indexPath)
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

// MARK: - StoryboardSceneBased
extension BooksOfflineViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

extension BooksOfflineViewController {
    var bindListBooksOffline: Binder<[BookItem]> {
        return Binder(self) { (vc, list) in
            vc.listBooksOffline = list
            vc.tableView.reloadData()
        }
    }
    
    var bindDeleteBook: Binder<Bool> {
        return Binder(self) { (vc, deleteStatus) in
            if deleteStatus {
                self.tableView.reloadData()
            } else {
                let alert = UIAlertController(title: "Error", message: "Delete book fail!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                vc.present(alert, animated: true, completion: nil)
            }
        }
    }
}
