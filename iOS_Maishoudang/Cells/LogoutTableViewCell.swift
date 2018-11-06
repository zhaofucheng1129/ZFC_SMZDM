//
//  LogoutTableViewCell.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/8/7.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LogoutTableViewCell: UITableViewCell, CellBindViewModelProtocol {
    
    private var bag = DisposeBag()
    
    @IBOutlet weak var logoutButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        logoutButton.rx.tap.bind {
            let alert = UIAlertController(title: "提示", message: "是否提退出登陆", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (alertAction) in
                CacheManager.logout()
            }))
            NavigationMediator.CurrentViewController()?.present(alert, animated: true, completion: nil)
        }.disposed(by: bag)
    }
    
    func bind(with vm: CellViewModelProtocol) {
        
    }
    
    
}
