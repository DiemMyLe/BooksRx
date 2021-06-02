//
//  CategoryViewController.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit
import Reusable
import MGArchitecture
import RxSwift
import RxCocoa

class CategoryViewController: UIViewController, Bindable {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnClearCache: UIButton!
    @IBOutlet weak var btnBooksOffline: UIBarButtonItem!
    
    var viewModel: CategoryViewModel!
    var disposeBag = DisposeBag()
    
    var listCategories = [Category]()
//    var selectCategoryTrigger = PublishSubject<Category>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Categories"
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        collectionView.register(cellType: CategoryCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func bindViewModel() {
//        let input = CategoryViewModel.Input(loadTrigger: Driver.just(()),
//                                            selectCategoryTrigger: selectCategoryTrigger.asDriverOnErrorJustComplete())
        let input = CategoryViewModel.Input(loadTrigger: Driver.just(()),
                                            selectCategoryTrigger: collectionView.rx.itemSelected.asDriver(),
                                            deleteAllBookTrigger: btnClearCache.rx.tap.asDriver(),
                                            loadBooksOffline: btnBooksOffline.rx.tap.asDriver())
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.listCategories
            .drive(bindListCategories)
            .disposed(by: disposeBag)
        
        output.categoryItem
        .drive()
        .disposed(by: disposeBag)
        
        output.isDeleteAllBookSuccess
            .drive(bindAlertClearCache)
            .disposed(by: disposeBag)
        
        output.goListBooksOffline
            .drive().disposed(by: disposeBag)
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CategoryCell.self)
        cell.setUpCell(item: listCategories[indexPath.row])
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let category = listCategories[indexPath.row]
//        selectCategoryTrigger.onNext(category)
//    }
}

extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: ((collectionView.frame.width - 30)/2) - 15, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 15, bottom: 0, right: 15)
    }
}

// MARK: - StoryboardSceneBased
extension CategoryViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

// MARK: - Binder
extension CategoryViewController {
    var bindListCategories: Binder<[Category]> {
        return Binder(self) { (vc, list) in
            vc.listCategories = list
            self.collectionView.reloadData()
        }
    }
    
    var bindAlertClearCache: Binder<Bool> {
        return Binder(self) { (vc, status) in
            let message = status ? "Xoá thành công rồi nga!" : "Gòy xong phim!\nXoá hông được rồi!"
            
            let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tắt đây nè!", style: .cancel, handler: nil))
            vc.present(alert, animated: true, completion: nil)
        }
    }
}
