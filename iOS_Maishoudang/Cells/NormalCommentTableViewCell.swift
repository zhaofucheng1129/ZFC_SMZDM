//
//  CommentTableViewCell.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/25.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import SwifterSwift

class NormalCommentTableViewCell: UITableViewCell, CellBindViewModelProtocol {

    @IBOutlet weak var cover: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var floor: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var content: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cover.roundCorners(.allCorners, radius: cover.width / 2)
    }
    
    func bind(with vm: CellViewModelProtocol) {
        let normalVM = vm as! NormalCommentTableViewCellViewModel
        
        cover.msd_setImage(with: normalVM.comment.coverUrl)
        
        userName.text = normalVM.comment.username
        floor.text = "\(normalVM.comment.floor)楼"
        time.text = normalVM.comment.createdAt?.compareCurrentTime()
        
        content.attributedText = normalVM.content
    }
}
