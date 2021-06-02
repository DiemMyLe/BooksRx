//
//  BooksOfflineCell.swift
//  EBook_Rx
//
//  Created by le.thi.diem.my on 6/1/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit
import Reusable

class BooksOfflineCell: UITableViewCell, NibReusable {
    @IBOutlet weak var imgBook: UIImageView!
    @IBOutlet weak var viewContentBook: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbAuthor: UILabel!
    @IBOutlet weak var lbPages: UILabel!
    
    var deleteBookAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(bookItem: BookItem) {
        self.backgroundColor = .clear
        viewContentBook.layer.cornerRadius = 10
        
        imgBook.loadImageFromURL(urlString: bookItem.urlImageBook ?? "")
        lbTitle.text = bookItem.title
        lbAuthor.text = bookItem.author
        lbPages.text = "\(bookItem.pages ?? "") trang"
    }
    
    @IBAction func deleteBook(_ sender: Any) {
        print("delete book ...")
        deleteBookAction?()
    }
}
