//
//  NormalCommentTableViewCellViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/25.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation
import RxSwift

struct NormalCommentTableViewCellViewModel: CellViewModelProtocol {
    
    var comment: Comment
    
    var cellSelecteCommand: Observable<Void>?
    
    private var bag: DisposeBag {
        return DisposeBag()
    }
    
    var content: NSMutableAttributedString {
        return comment.content.formatContent()
    }
    
    func cellReuseIdentifier() -> String {
        return CellReuseIdentifierManager.NormalCommentCellId
    }
    
    func cellSelected() {
        if let command = cellSelecteCommand {
            command.subscribe().disposed(by: bag)
        }
    }
}
