//
//  SearchViewController.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/8/7.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

class SearchViewController: MSDBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isHidden = true
        
        let searchBar = Bundle.main.loadNibNamed("SearchBarView", owner: nil, options: nil)?.last as! SearchBarView
        
        self.view.insertSubview(searchBar, belowSubview: statusBar)
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(statusBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
