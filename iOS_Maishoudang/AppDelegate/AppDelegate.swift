//
//  AppDelegate.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/6/30.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var unionLoginBack: Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //阿里百川
        AlibcTradeSDK.sharedInstance().asyncInit(success: {
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
        }
        
        // 开发阶段打开日志开关，方便排查错误信息
        //默认调试模式打开日志,release关闭,可以不调用下面的函数
//        AlibcTradeSDK.sharedInstance().setDebugLogOpen(true)
        
        // 设置全局配置，是否强制使用h5
        AlibcTradeSDK.sharedInstance().setIsForceH5(false)
        
        //统计
        UMConfigure.initWithAppkey("581964eea325112419003df9", channel: "App Store")
        
        //登陆
        UMSocialManager.default().setPlaform(.wechatSession, appKey: "wxf7fd4298e808b3de", appSecret: "4fc251eaac3465473cbcfa509ffb8221", redirectURL: "http://mobile.umeng.com/social")
        UMSocialManager.default().setPlaform(.QQ, appKey: "101137910", appSecret: "f4740a27de6c50bbb0262aed67b4af72", redirectURL: "http://mobile.umeng.com/social")
        UMSocialManager.default().setPlaform(.sina, appKey: "747140017", appSecret: "f7b3e54ca4d17b4f5876a387ce0745d2", redirectURL: "http://www.maishoudang.com/auth/weibo/callback")
        
        IQKeyboardManager.shared.enable = true
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            if let message = UserDefaults.standard.object(forKey: "UnionLogin") as? String, !message.isEmpty, !self.unionLoginBack {
                UserDefaults.standard.set("", forKey: "UnionLogin")
                self.unionLoginBack = false
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UnionLoginBackNotification"), object: message)
            } else {
                self.unionLoginBack = false
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    
    // 支持所有iOS系统
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
        let result = UMSocialManager.default().handleOpen(url, sourceApplication: sourceApplication, annotation: annotation)
        if !result {
            // 其他如支付等SDK的回调
        }
        
        unionLoginBack = true
        return result
    }
    
    //仅支持iOS9以上系统，iOS8及以下系统不会回调
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let result = UMSocialManager.default().handleOpen(url, options: options)
        if !result {
            // 其他如支付等SDK的回调
        }
        
        unionLoginBack = true
        return result
    }
    
    //支持目前所有iOS系统
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let result = UMSocialManager.default().handleOpen(url)
        if !result {
            // 其他如支付等SDK的回调
        }
        
        unionLoginBack = true
        return result
    }
}

