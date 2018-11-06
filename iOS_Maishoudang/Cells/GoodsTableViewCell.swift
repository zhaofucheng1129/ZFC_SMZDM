//
//  GoodsTableViewCell.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/21.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import SDWebImage
import SwifterSwift

class GoodsTableViewCell: UITableViewCell, CellBindViewModelProtocol {

    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var zan: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        cover.kf.setImage(with: URL(string: "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=173304614,2609782056&fm=27&gp=0.jpg"))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cover.roundCorners(.allCorners, radius: 2.5)
    }
    
    func bind(with vm: CellViewModelProtocol) {
        let goodsVM = vm as! GoodsTableViewCellViewModel
        
        cover.msd_setImage(with: goodsVM.product.image)
        
        userName.text = goodsVM.product.author ?? ""
        title.text = goodsVM.product.name ?? ""
        time.text = goodsVM.time
        zan.text = String(goodsVM.product.agreeCount)
        comment.text = String(goodsVM.product.commentsCount)
        subTitle.text = goodsVM.product.subtitle ?? ""
    }
}
