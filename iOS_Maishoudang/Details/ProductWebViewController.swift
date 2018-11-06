//
//  ProductWebViewController.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/8/7.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import SnapKit

class ProductWebViewController: MSDBaseViewController {

    let webView = UIWebView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "商品详情"
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
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
        webView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ProductWebViewController: UIWebViewDelegate {
    
}
