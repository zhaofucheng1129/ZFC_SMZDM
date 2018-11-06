//
//  MainHeaderTableViewCellViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/27.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

struct MainHeaderTableViewCellViewModel: CellViewModelProtocol {
    
    func cellReuseIdentifier() -> String {
        return CellReuseIdentifierManager.MainHeaderCellId
    }
    
    func cellSelected() {
        CacheManager.checkLogin {
            let alert = UIAlertController(title: "提示", message: "已经登陆成功", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
            NavigationMediator.CurrentViewController()?.present(alert, animated: true, completion: nil)
        }
    }
}
