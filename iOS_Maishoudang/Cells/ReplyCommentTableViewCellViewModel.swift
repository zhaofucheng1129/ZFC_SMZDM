//
//  ReplyCommentTableViewCellViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/25.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation
import RxSwift

struct ReplyCommentTableViewCellViewModel: CellViewModelProtocol {
    
    var comment: Comment
    
    var cellSelecteCommand: Observable<Void>?
    
    private var bag: DisposeBag {
        return DisposeBag()
    }
    
    var content: NSMutableAttributedString {
        return comment.content.formatContent()
    }
    
    var parentContent: NSMutableAttributedString {
        var floorText = NSMutableAttributedString(string: "")
        
        if let floor = comment.parent?.floor, let userName = comment.parent?.username {
            let str = "//\(floor)楼 \(userName):"
            floorText = NSMutableAttributedString(string: str)
            floorText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14.0), range: NSMakeRange(0, str.count))
            floorText.addAttribute(.foregroundColor, value: UIColor(hexString: "333333")!, range: NSMakeRange(0, str.count))
        }
        
        let attrString = comment.parent?.content.formatContent() ?? NSMutableAttributedString(string: "")
        attrString.insert(floorText, at: 0)
        
        return attrString
    }
    
    func cellReuseIdentifier() -> String {
        return CellReuseIdentifierManager.ReplyCommentCellId
    }
    
    func cellSelected() {
        if let command = cellSelecteCommand {
           command.subscribe().disposed(by: bag)
        }
    }
}
