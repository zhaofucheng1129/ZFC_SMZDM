//
//  LoginView.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/27.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwifterSwift

class LoginRootView: UIView {

    private var bag = DisposeBag()
    
    @IBOutlet weak var sendAuthCodeBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var accountLoginBtn: UIButton!
    
    @IBOutlet weak var weiboSignBtn: UIButton!
    
    @IBOutlet weak var qqSignBtn: UIButton!
    
    @IBOutlet weak var weChatSignBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sendAuthCodeBtn.borderWidth = 1 / UIScreen.main.nativeScale
        sendAuthCodeBtn.borderColor = UIColor(hexString: "F3574E")!
        sendAuthCodeBtn.cornerRadius = 2.5
        
        loginBtn.roundCorners(.allCorners, radius: 2.5)
        
        accountLoginBtn.rx.tap.bind {
            NavigationMediator.TopNavigationViewController()?.pushViewController(NavigationMediator.AccountLoginPage(), animated: true)
        }.disposed(by: bag)
    }

    func bind(vm: LoginViewControllerViewModel) {
        qqSignBtn.rx.tap.bind {
            let _ = vm.qqLoginCommand.subscribe()
        }.disposed(by: bag)
        
        weiboSignBtn.rx.tap.bind {
            let _ = vm.weiboLoginCommand.subscribe()
        }.disposed(by: bag)
        
        weChatSignBtn.rx.tap.bind {
            let _ = vm.weChatLoginCommand.subscribe()
        }.disposed(by: bag)
    }
    
}
