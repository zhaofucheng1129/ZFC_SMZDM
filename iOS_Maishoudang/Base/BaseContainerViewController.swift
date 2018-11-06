//
//  BaseContainerViewController.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/8/8.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import SnapKit

class BaseContainerViewController: MSDBaseViewController {

    var subViewController: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = subViewController.title ?? ""
        
        view.backgroundColor = UIColor.white
        
        //添加控制器
        self.addChildViewController(subViewController)
        //添加视图
        view.addSubview(subViewController.view)
        subViewController.view.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    
    init(vc: UIViewController) {
        self.subViewController = vc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
