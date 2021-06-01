//
//  BookListCell.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit
import Reusable

class BookListCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var imgBook: UIImageView!
    @IBOutlet weak var lbBookName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpCell(item: Book) {
        imgBook.loadImageFromURL(urlString: item.thumbnail)
        imgBook.layer.borderColor = UIColor.green.cgColor
        imgBook.layer.borderWidth = 1
        imgBook.layer.cornerRadius = 8
        
        lbBookName.text = item.title
    }
}
