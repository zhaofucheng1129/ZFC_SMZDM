//
//  NavigationMediator.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/24.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation

class NavigationMediator {
    
    private var navigationStack: [UINavigationController] = []
    
    static let shared = NavigationMediator()
    
    private init() {
        
    }
    
    public class func GoodPriceDetailPage(commentableType: recommendType, productId: UInt) -> UIViewController {
        let vm = ProductDetailViewControllerViewModel(commentableType: commentableType, productId: productId)
        return GoodPriceDetailViewController(vm: vm)
    }
    
    public class func CommentListPage(commentableType: String, commentableId: UInt) -> UIViewController {
        let vm = CommentListViewControllerViewModel(commentableType: commentableType, commentableId: commentableId)
        return CommentListViewController(vm: vm)
    }
    
    public class func PublishPage() -> UIViewController {
        return PublishViewController()
    }
    
    public class func SearchPage() -> UIViewController {
        return SearchViewController()
    }
    
    
    public class func LoginPage() -> UIViewController {
        return LoginNavViewController(rootViewController: LoginViewController())
    }
    
    public class func AccountLoginPage() -> UIViewController {
        return AccountLoginViewController()
    }
    
    
    public func pushNavigationViewController(nav: UINavigationController) {
        navigationStack.push(nav)
    }
    
    public func popNavigationViewController() -> UINavigationController? {
        return navigationStack.pop()
    }
    
    public class func TopNavigationViewController() -> UINavigationController? {
        return shared.navigationStack.last
//        return self.CurrentViewController()?.navigationController
    }
    
    public class func CurrentViewController() -> UIViewController? {
        
        return TopNavigationViewController()?.visibleViewController
        
//        //获取默认的Window
//        var keyWindow = UIApplication.shared.keyWindow
//        if let window = keyWindow, window.windowLevel != UIWindowLevelNormal {
//            let windows = UIApplication.shared.windows
//            for tempWin in windows {
//                if tempWin.windowLevel == UIWindowLevelNormal {
//                    keyWindow = tempWin
//                    break
//                }
//            }
//        }
//
//        // 获取window的rootViewController
//        var result = keyWindow?.rootViewController
//        while (result?.presentedViewController != nil) {
//            result = result?.presentedViewController
//        }
//
//        if let isTabbar = result?.isKind(of: UITabBarController.self), isTabbar {
//            result = (result as! UITabBarController).selectedViewController
//        }
//
//        if let isNav = result?.isKind(of: UINavigationController.self), isNav {
//            result = (result as! UINavigationController).visibleViewController
//        }
//
//        return result
    }
}
