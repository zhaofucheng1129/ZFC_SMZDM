//
//  CacheManager.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/8/3.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import KeychainAccess
import RxCocoa
import RxSwift

class CacheManager: NSObject {

    static let shared: CacheManager = CacheManager()
    
    private let currentUserSubject = PublishSubject<User?>()
    var currentUser: Observable<User?> {
        return currentUserSubject.asObservable()
    }
    
    private override init() {
        
    }
    
    class func saveDeviceInfo(device: MsdDevice) {
        let data = NSKeyedArchiver.archivedData(withRootObject: device)
        UserDefaults.standard.set(data, forKey: "MSDDeviceInfo")
        
        CacheManager.saveSubscribeBestPriceStatus(status: device.subscribeBestPrice)
        CacheManager.saveSubscribeNoticeStatus(status: device.subscribeNotice)
    }
    
    class func saveDeviceId(deviceId: String) {
        let keychain = Keychain(service: "com.zhaofucheng.SixCityMSD")
        keychain["deviceId"] = deviceId
    }
    
    class func getDeviceId() -> String? {
        let keychain = Keychain(service: "com.zhaofucheng.SixCityMSD")
        return keychain["deviceId"]
    }
    
    class func saveSubscribeBestPriceStatus(status: Bool) {
        UserDefaults.standard.set(status, forKey: "MSDSubscribeBestPriceStatus")
        UserDefaults.standard.synchronize()
    }
    
    class func saveSubscribeNoticeStatus(status: Bool) {
        UserDefaults.standard.set(status, forKey: "MSDSubscribeNoticeStatus")
        UserDefaults.standard.synchronize()
    }
    
    class func saveUserInfo(userInfo: User) {
        let data = NSKeyedArchiver.archivedData(withRootObject: userInfo)
        UserDefaults.standard.set(data, forKey: "KEY_USERINFO")
        UserDefaults.standard.set(userInfo.authorizeToken, forKey: "MSDAuthorizeToken")
        
        CacheManager.saveSubscribeNoticeStatus(status: userInfo.subscribeNotice)
        CacheManager.saveSubscribeBestPriceStatus(status: userInfo.subscribeBestPrice)
        
        shared.currentUserSubject.onNext(userInfo)
    }
    
    class func getAuthorizeToken() -> String? {
        let token = UserDefaults.standard.object(forKey: "MSDAuthorizeToken") as? String
        return token
    }
    
    class func getUserInfo() -> User? {
        guard let data = UserDefaults.standard.object(forKey: "KEY_USERINFO") as? Data,
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else {
            return nil
        }
        
        return user
    }
    
    class func checkLogin(block:() -> Void) {
        if let _ = getAuthorizeToken() {
            block()
        } else {
            NavigationMediator.CurrentViewController()?.present(NavigationMediator.LoginPage(), animated: true, completion: nil)
        }
    }
    
    class func logout() {
        UserDefaults.standard.set(nil, forKey: "KEY_USERINFO")
        UserDefaults.standard.set(nil, forKey: "MSDAuthorizeToken")
        UserDefaults.standard.synchronize()
        shared.currentUserSubject.onNext(nil)
    }
}
