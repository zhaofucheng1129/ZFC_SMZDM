//
//  LoginViewController.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/27.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import PKHUD

class LoginViewController: MSDBaseViewController {
    
    private let loginVM = LoginViewControllerViewModel()
    
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let customBackButton = UIButton(type: .system)
        customBackButton.setImage(backButton.image(for: .normal), for: .normal)
        customBackButton.contentHorizontalAlignment = backButton.contentHorizontalAlignment
        view.addSubview(customBackButton)
        customBackButton.snp.makeConstraints { (make) in
            make.center.equalTo(backButton)
            make.size.equalTo(backButton)
        }
        customBackButton.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: bag)
        
        if let loginView = Bundle.main.loadNibNamed("LoginRootView", owner: nil, options: nil)?.last as? LoginRootView {
            view.addSubview(loginView)
            loginView.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(navigationBar.snp.bottom)
                if #available(iOS 11.0, *) {
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                } else {
                    make.bottom.equalTo(view.snp.bottom)
                }
            }
            
            loginView.bind(vm: loginVM)
        }
        
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: "UnionLoginBackNotification")).subscribe(onNext: { (notification) in
            if let message = notification.object as? String {
                HUD.flash(.label(message),delay: 1.0)
            }
        }).disposed(by: bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
