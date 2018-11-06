//
//  CommentHeaderTableViewCellViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/26.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

struct CommentHeaderTableViewCellViewModel: CellViewModelProtocol {
    func cellReuseIdentifier() -> String {
        return CellReuseIdentifierManager.CommentHeaderCellId
    }
}
