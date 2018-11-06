//
//  GoodPriceTableViewCellViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/22.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation

struct GoodPriceTableViewCellViewModel: CellViewModelProtocol {
    func cellReuseIdentifier() -> String {
        return CellReuseIdentifierManager.GoodPriceCellId
    }
    
    var product: Product
    
    var sourceAndTime: String {
        return "\(product.merchantName ?? "") | \(product.publishedAt.compareCurrentTime())"
    }
    
    func cellSelected() {
        NavigationMediator.TopNavigationViewController()?.pushViewController(NavigationMediator.GoodPriceDetailPage(commentableType: product.type, productId: product.id), animated: true)
    }
}
