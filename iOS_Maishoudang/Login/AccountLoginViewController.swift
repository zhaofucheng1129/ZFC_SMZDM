//
//  AccountLoginViewController.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/8/1.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class AccountLoginViewController: MSDBaseViewController {
    
    private let accountLoginVM = AccountLoginViewControllerViewModel()
    
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let accountLoginView = Bundle.main.loadNibNamed("AccountLoginRootView", owner: nil, options: nil)?.last as? AccountLoginRootView {
            view.addSubview(accountLoginView)
            accountLoginView.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(navigationBar.snp.bottom)
                if #available(iOS 11.0, *) {
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                } else {
                    make.bottom.equalTo(view.snp.bottom)
                }
            }
            
            let validatedUsername = accountLoginView.userNameField.rx.text
            let validatedPassword = accountLoginView.passwordField.rx.text
            
            Observable.combineLatest(validatedUsername, validatedPassword).map({ (userName,password) -> Bool in
                if let userName = userName, let password = password, userName != "", password != "" {
                    return true
                } else {
                    return false
                }
            }).bind { (enable) in
                if enable {
                    accountLoginView.loginBtn.isUserInteractionEnabled = true
                    accountLoginView.loginBtn.alpha = 1
                } else {
                    accountLoginView.loginBtn.isUserInteractionEnabled = false
                    accountLoginView.loginBtn.alpha = 0.3
                }
            }.disposed(by: bag)
            
            accountLoginView.loginBtn.rx.tap.bind { [weak self] in
                if let userName = accountLoginView.userNameField.text, let password = accountLoginView.passwordField.text {
                    self?.accountLoginVM.requestLogin(userName: userName, passwd: password)
                }
            }.disposed(by: bag)
        }
    }

}
