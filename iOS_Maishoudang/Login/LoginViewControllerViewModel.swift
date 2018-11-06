//
//  LoginViewControllerViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/8/1.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

class LoginViewControllerViewModel: NSObject {
    
    private var bag = DisposeBag()
    
    let loginCommand: Observable<Void> = Observable<Void>.create { (observer) -> Disposable in
        
        observer.onCompleted()
        return Disposables.create { }
    }
    
    var weChatLoginCommand: Observable<Void>!
    
    var weiboLoginCommand: Observable<Void>!
    
    var qqLoginCommand: Observable<Void>!
    
    override init() {
        super.init()
        
        self.weChatLoginCommand = Observable<Void>.create { [weak self] (observer) -> Disposable in
            HUD.show(.progress)
            UserDefaults.standard.set("微信返回", forKey: "UnionLogin")
            UserDefaults.standard.synchronize()
            UMSocialManager.default().getUserInfo(with: .wechatSession, currentViewController: nil, completion: { (result, error) in
                UserDefaults.standard.set("", forKey: "UnionLogin")
                UserDefaults.standard.synchronize()
                if let error = error as NSError? {
                    if let message = error.userInfo["message"] as? String {
                        HUD.flash(.labeledError(title: "错误", subtitle: message),delay: 1.0)
                    } else {
                        HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription),delay: 1.0)
                    }
                } else if result != nil,let resp = result as? UMSocialUserInfoResponse {
                    HUD.hide(animated: true)
                    // print("uid:\(resp.openid),name:\(resp.name),image:\(resp.iconurl)")
                    self?.doRequestUnionLogin(provider: "qq_connect", uid: resp.openid, nickName: resp.name, imageUrl: resp.iconurl)
                } else {
                    HUD.flash(.labeledError(title: "错误", subtitle: "无效数据"),delay: 1.0)
                }
            })
            
            observer.onCompleted()
            return Disposables.create {}
        }
        
        self.weiboLoginCommand = Observable<Void>.create { [weak self] (observer) -> Disposable in
            HUD.show(.progress)
            UserDefaults.standard.set("微博返回", forKey: "UnionLogin")
            UserDefaults.standard.synchronize()
            UMSocialManager.default().getUserInfo(with: .sina, currentViewController: nil, completion: { (result, error) in
                UserDefaults.standard.set("", forKey: "UnionLogin")
                UserDefaults.standard.synchronize()
                if let error = error as NSError? {
                    if let message = error.userInfo["message"] as? String {
                        HUD.flash(.labeledError(title: "错误", subtitle: message),delay: 1.0)
                    } else {
                        HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription),delay: 1.0)
                    }
                } else if result != nil,let resp = result as? UMSocialUserInfoResponse {
                    HUD.hide(animated: true)
                    // print("uid:\(resp.uid),name:\(resp.name),image:\(resp.iconurl)")
                    self?.doRequestUnionLogin(provider: "weibo", uid: resp.uid, nickName: resp.name, imageUrl: resp.iconurl)
                } else {
                    HUD.flash(.labeledError(title: "错误", subtitle: "无效数据"),delay: 1.0)
                }
            })
            
            observer.onCompleted()
            return Disposables.create {}
        }
        
        self.qqLoginCommand = Observable<Void>.create({ [weak self] (observer) -> Disposable in
            HUD.show(.progress)
            UserDefaults.standard.set("QQ返回", forKey: "UnionLogin")
            UMSocialManager.default().getUserInfo(with: .QQ, currentViewController: nil, completion: { (result, error) in
                if let error = error as NSError? {
                    if let message = error.userInfo["message"] as? String {
                        HUD.flash(.labeledError(title: "错误", subtitle: message),delay: 1.0)
                    } else {
                        HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription),delay: 1.0)
                    }
                } else if result != nil,let resp = result as? UMSocialUserInfoResponse {
                    HUD.hide(animated: true)
                    // print("uid:\(resp.openid),name:\(resp.name),image:\(resp.iconurl)")
                    self?.doRequestUnionLogin(provider: "qq_connect", uid: resp.openid, nickName: resp.name, imageUrl: resp.iconurl)
                } else {
                    HUD.flash(.labeledError(title: "错误", subtitle: "无效数据"),delay: 1.0)
                }
            })
            
            observer.onCompleted()
            return Disposables.create {}
        })
    }
    
    func doRequestUnionLogin(provider:String, uid: String, nickName:String, imageUrl:String) {
        HUD.show(.labeledProgress(title: "授权成功", subtitle: "正在登陆中"))
        requestUnionLogin(provider: provider, uid: uid, nickName: nickName, imageUrl: imageUrl).subscribe(onNext: { (user) in
            CacheManager.saveUserInfo(userInfo: user)
            NavigationMediator.TopNavigationViewController()?.dismiss(animated: true, completion: nil)
        }, onError: { (error) in
            HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription), delay: 1.0)
        }, onCompleted: {
            HUD.flash(.success, delay:1.0)
        }).disposed(by: bag)
    }
    
    private func requestUnionLogin(provider:String, uid: String, nickName:String, imageUrl:String) -> Observable<User> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return msdApiProvider.rx.request(.unionLoginApi(provider: provider, uid: uid, nickName: nickName, imageUrl: imageUrl)).map(User.self, atKeyPath: nil, using: decoder, failsOnEmptyData: false).asObservable()
    }
}
