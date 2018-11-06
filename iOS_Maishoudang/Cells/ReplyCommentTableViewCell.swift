//
//  ReplyCommentTableViewCell.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/25.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

class ReplyCommentTableViewCell: UITableViewCell, CellBindViewModelProtocol {
    
    @IBOutlet weak var cover: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var floor: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var parentContent: UITextView!
    
    @IBOutlet weak var content: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cover.roundCorners(.allCorners, radius: cover.width / 2)
//        cover.addShadow(ofColor: UIColor.black, radius: 4, offset: CGSize(width: 5, height: 5), opacity: 0.8)
    }

    func bind(with vm: CellViewModelProtocol) {
        let replyVM = vm as! ReplyCommentTableViewCellViewModel
        
        cover.msd_setImage(with: replyVM.comment.coverUrl)
        
        userName.text = replyVM.comment.username
        floor.text = "\(replyVM.comment.floor)楼"
        time.text = replyVM.comment.createdAt?.compareCurrentTime()
        
        parentContent.attributedText = replyVM.parentContent
        
        content.attributedText = replyVM.content
        
        
    }
}
