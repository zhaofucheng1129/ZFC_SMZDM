//
//  BargainTableViewCell.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/20.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import SwifterSwift

class GoodPriceTableViewCell: UITableViewCell,CellBindViewModelProtocol {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var sourceAndTime: UILabel!
    @IBOutlet weak var zan: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImage.roundCorners(.allCorners, radius: 2.5)
//        productImage.kf.setImage(with: URL(string:"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3535280587,3787524484&fm=27&gp=0.jpg"))
    }
    
    func bind(with vm: CellViewModelProtocol) {
        let goodPriceVM = vm as! GoodPriceTableViewCellViewModel

        productImage.msd_setImage(with: goodPriceVM.product.image)
        
        title.text = goodPriceVM.product.name
        subTitle.text = goodPriceVM.product.subtitle
        sourceAndTime.text = goodPriceVM.sourceAndTime
        zan.text = String(goodPriceVM.product.agreeCount)
        comment.text = String(goodPriceVM.product.commentsCount)
    }
}
