//
//  MainItemTableViewCellViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/27.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

struct MainItemTableViewCellViewModel: CellViewModelProtocol {
    
    var info: [String:String]
    
    var iconName: String {
        return info["icon"] ?? ""
    }
    
    var itenMame: String {
        return info["item"] ?? ""
    }
    
    func cellReuseIdentifier() -> String {
        return CellReuseIdentifierManager.MainItemCellId
    }
}
