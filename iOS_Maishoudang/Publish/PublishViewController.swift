//
//  PublishViewController.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/8/8.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

class PublishViewController: MSDBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "发布"
        
        view.backgroundColor = UIColor.white
        
        let richTextEditor = RichTextEditorViewController()
        //添加控制器
        self.addChildViewController(richTextEditor)
        //添加视图
        view.addSubview(richTextEditor.view)
        richTextEditor.view.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
