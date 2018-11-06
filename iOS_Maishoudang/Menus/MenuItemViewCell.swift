//
//  MenuItemViewCell.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/8/8.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

class MenuItemViewCell: UITableViewCell {
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bind(with model: [String:String]) {
        if let name = model["itemName"] {
            itemName.text = name
        }
        
        if let icon = model["iconName"] {
            iconView.image = UIImage(named: icon)
        }
    }
    
}
