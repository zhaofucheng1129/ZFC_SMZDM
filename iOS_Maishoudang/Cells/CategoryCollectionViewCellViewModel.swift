//
//  CategoryCollectionViewCellViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/30.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation

struct CategoryCollectionViewCellViewModel: CellViewModelProtocol {
    
    var category: Category
    
    func cellReuseIdentifier() -> String {
        return CellReuseIdentifierManager.CategoryCollectionCellId
    }
    
    func cellSize() -> CGSize {
        let name = category.name
        
        if !name.isEmpty {
            let attributeString = NSMutableAttributedString(string: name, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)])
            let size = attributeString.boundingRect(with: CGSize.zero, options: .usesLineFragmentOrigin, context: nil).size
            return CGSize(width: size.width + 5, height: size.height)
        }
        
        return CGSize.zero
    }
}
