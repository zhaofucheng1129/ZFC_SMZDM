//
//  SearchViewControllerViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/8/9.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewControllerViewModel: NSObject {
    private var bag = DisposeBag()

    var showSearchHistorySubject = PublishSubject<Bool>()
    
    
}
