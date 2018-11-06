//
//  CommentOperationView.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/30.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

class CommentOperationView: UIView {

    @IBOutlet weak var textViewBackground: UIView!

    @IBOutlet weak var commentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textViewBackground.layer.cornerRadius = 15.0
        textViewBackground.layer.borderColor = UIColor(hexString: "666666")?.cgColor
        textViewBackground.layer.borderWidth = 1 / UIScreen.main.nativeScale
        
        
        commentTextView.placeholder = "写评论"
        commentTextView.placeholderColor = UIColor(hexString: "A9A9A9")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        textViewBackground.roundCorners(.allCorners, radius: 15)
    }

}
