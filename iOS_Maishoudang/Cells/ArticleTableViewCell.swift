//
//  ArticleTableViewCell.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/21.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import SwifterSwift

class ArticleTableViewCell: UITableViewCell,CellBindViewModelProtocol {

    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var zan: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        cover.kf.setImage(with: URL(string: "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1604533180,2127319103&fm=27&gp=0.jpg"))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cover.roundCorners(.allCorners, radius: 2.5)
    }
    
    func bind(with vm: CellViewModelProtocol) {
        let articleVM = vm as! ArticleTableViewCellViewModel
        
        cover.msd_setImage(with: articleVM.product.image)
        
        title.text = articleVM.product.name ?? ""
        zan.text = String(articleVM.product.agreeCount)
        comment.text = String(articleVM.product.commentsCount)
        time.text = articleVM.time
        userName.text = articleVM.product.author ?? ""
        subTitle.text = articleVM.product.subtitle ?? ""
    }
}
