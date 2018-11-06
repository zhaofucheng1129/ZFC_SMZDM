//
//  LogoutTableViewCellViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/8/7.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

struct LogoutTableViewCellViewModel: CellViewModelProtocol {
        
    func cellReuseIdentifier() -> String {
        return CellReuseIdentifierManager.LogoutCellId
    }
    
    func cellSelected() {
        
    }
    
}
