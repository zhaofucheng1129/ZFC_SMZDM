//
//  GoodsTableViewCellViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/23.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

struct GoodsTableViewCellViewModel: CellViewModelProtocol {
    
    var product: Product
    
    var time: String {
        return product.publishedAt.dateTime(format: "MM-dd")
    }
    
    func cellReuseIdentifier() -> String {
        return CellReuseIdentifierManager.GoodsCellId
    }
    
    func cellSelected() {
        NavigationMediator.TopNavigationViewController()?.pushViewController(NavigationMediator.GoodPriceDetailPage(commentableType: product.type, productId: product.id), animated: true)
    }
}
