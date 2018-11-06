//
//  HomeCategoriesTableViewCellViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/22.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation

struct HomeCategoriesTableViewCellViewModel: CellViewModelProtocol {
    func cellReuseIdentifier() -> String {
        return CellReuseIdentifierManager.HomeCategoriesCellId
    }
    
    func cellSelected() {
        
    }
}
