//
//  RecommendListCollectionViewCellViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/30.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation

protocol RecommendListCollectionViewCellViewModel: CellViewModelProtocol {
    
    var dataSource: [CellViewModelProtocol] { get set }
    
    func requestNewData(complete:@escaping ((Error?)->Void))
    
    func requestNextPageData(complete:@escaping ((Error?)->Void))
    
}
