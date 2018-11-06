//
//  CategoryCollectionViewCell.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/30.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell, CellBindViewModelProtocol {
    
    @IBOutlet weak var name: UILabel!
    
    func bind(with vm: CellViewModelProtocol) {
        let categoryVM = vm as! CategoryCollectionViewCellViewModel
        name.text = categoryVM.category.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
