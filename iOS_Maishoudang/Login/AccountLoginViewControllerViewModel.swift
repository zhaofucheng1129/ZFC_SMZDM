//
//  AccountLoginViewControllerViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/8/7.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PKHUD

struct AccountLoginViewControllerViewModel {
    private var bag = DisposeBag()
    
    func requestLogin(userName: String, passwd: String) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        HUD.show(.labeledProgress(title: "提示", subtitle: "正在登陆中"))
        msdApiProvider.rx.request(.loginApi(userName: userName, passwd: passwd)).map(User.self, atKeyPath: nil, using: decoder, failsOnEmptyData: false).asObservable().subscribe(onNext: { (user) in
            CacheManager.saveUserInfo(userInfo: user)
            NavigationMediator.TopNavigationViewController()?.dismiss(animated: true, completion: nil)
        }, onError: { (error) in
            HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription), delay: 1.0)
        }, onCompleted: {
            HUD.flash(.success, delay:1.0)
        }, onDisposed: {
            
        }).disposed(by: bag)
    }
    
}
