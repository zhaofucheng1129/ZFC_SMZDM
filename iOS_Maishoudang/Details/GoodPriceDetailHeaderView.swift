//
//  GoodPriceDetailHeaderView.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/21.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

class GoodPriceDetailHeaderView: UIView {
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shortTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sourceLabel.text = ""
        titleLabel.text = ""
        shortTitleLabel.text = ""
    }
}
