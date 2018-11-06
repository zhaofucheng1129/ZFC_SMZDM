//
//  SearchBarView.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/8/8.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchBarView: UIView {

    private var bag = DisposeBag()
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backBtn.rx.tap.bind {
            NavigationMediator.TopNavigationViewController()?.popViewController(animated: true)
            }.disposed(by: bag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.roundCorners(.allCorners, radius: backgroundView.height / 2)
    }

}
