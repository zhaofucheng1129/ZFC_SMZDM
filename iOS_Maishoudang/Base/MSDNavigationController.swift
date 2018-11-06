//
//  MSDNavigationController.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/19.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

class MSDNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NavigationMediator.shared.pushNavigationViewController(nav: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _ = NavigationMediator.shared.popNavigationViewController()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        var toVc = viewController
        if let showVC = toVc as? MSDBaseViewController {
            if childViewControllers.count > 0 {
                showVC.hidesBackButton = false
                showVC.hidesTabBarWhenPushed = true
            }
        } else {
            toVc = BaseContainerViewController(vc: viewController)
            let showVC = toVc as! MSDBaseViewController
            if childViewControllers.count > 0 {
                showVC.hidesBackButton = false
                showVC.hidesTabBarWhenPushed = true
            }
        }
        
        super.pushViewController(toVc, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        
        return super.popViewController(animated: animated)
    }
}
