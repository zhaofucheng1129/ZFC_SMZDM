//
//  CellViewModelProtocol.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/22.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation

protocol CellViewModelProtocol {
    func cellReuseIdentifier() -> String
    
    func cellSelected()
    
    func cellHeight() -> CGFloat
}

extension CellViewModelProtocol {
    func cellSelected() {
        
    }
    
    func cellHeight() -> CGFloat {
        return 0
    }
    
    func cellSize() -> CGSize {
        return CGSize.zero
    }
}
