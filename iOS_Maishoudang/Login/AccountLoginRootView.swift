//
//  AccountLoginView.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/8/1.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import SwifterSwift

class AccountLoginRootView: UIView {

    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loginBtn.roundCorners(.allCorners, radius: 2.5)
    }

}
