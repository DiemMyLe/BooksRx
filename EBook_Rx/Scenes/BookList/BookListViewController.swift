//
//  BookListViewController.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import MGArchitecture

class BookListViewController: UIViewController, Bindable {

    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: BookListViewModel!
    var category = Category()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = category.title
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        collectionView.register(cellType: BookListCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func bindViewModel() {
        let input = BookListViewModel.Input(loadTrigger: Driver.just(()), selectBookTrigger: collectionView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.category
        .drive(bindCategory)
        .disposed(by: disposeBag)
        
        output.book
        .drive()
        .disposed(by: disposeBag)
    }
}

extension BookListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: BookListCell.self)
        cell.setUpCell(item: category.books[indexPath.row])
        return cell
    }
}

extension BookListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 15, bottom: 10, right: 15)
    }
}

// MARK: - StoryboardSceneBased
extension BookListViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

// MARK: - Binder
extension BookListViewController {
    var bindCategory: Binder<Category> {
        return Binder(self) { (vc, cate) in
            vc.category = cate
            self.collectionView.reloadData()
        }
    }
}
