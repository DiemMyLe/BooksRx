//
//  CategoryCell.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit
import Reusable

class CategoryCell: UICollectionViewCell, NibReusable {
    @IBOutlet weak var lbCategoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpCell(item: Category) {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        let color = UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1)
        self.layer.borderColor = color.cgColor
        lbCategoryName.textColor = color
        lbCategoryName.text = "\(item.title)"
    }
}


