//
//  MSDNavigationControllerDelegate.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/23.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

class MSDNavigationControllerDelegate:NSObject, UINavigationControllerDelegate {
    
    @IBOutlet public var percent:PercentDrivenTransition?
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return NavigationPageAnimator(operation: operation)
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController.isKind(of: NavigationPageAnimator.self) {
            if let isStart = self.percent?.isStart {
                return isStart ? self.percent : nil
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
