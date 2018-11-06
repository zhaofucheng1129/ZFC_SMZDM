//
//  BaseCategoryViewProtocol.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/31.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation

protocol BaseCategoryViewModelProtocol {
    
    var categoriesDataSource: [CellViewModelProtocol] {get set}
    
    var categoriesListDataSource: [CellViewModelProtocol] {get set}
    
    func requestNewData(complete:@escaping ((Error?)->Void))
    
}
