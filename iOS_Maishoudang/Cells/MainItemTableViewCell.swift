//
//  MainItemTableViewCell.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/26.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

class MainItemTableViewCell: UITableViewCell, CellBindViewModelProtocol {

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var item: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func bind(with vm: CellViewModelProtocol) {
        let itemVM = vm as! MainItemTableViewCellViewModel
        icon.image = UIImage(named: itemVM.iconName)
        item.text = itemVM.itenMame
    }
}
