//
//  HomeViewController.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/20.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import SnapKit
import UITableView_FDTemplateLayoutCell
import RxSwift
import RxCocoa
import SwifterSwift

class HomeViewController: BaseCategoryViewController {
    
    override func viewDidLoad() {
        self.baseVM = HomeViewControllerViewModel()
        
        super.viewDidLoad()
    }

}
