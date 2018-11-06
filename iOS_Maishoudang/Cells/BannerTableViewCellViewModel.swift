//
//  BannerTableViewCellViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/22.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation

struct BannerTableViewCellViewModel: CellViewModelProtocol {
    
    func cellReuseIdentifier() -> String {
        return CellReuseIdentifierManager.BannerCellId
    }
    
    var galleries: [Gallery]
    
    var galleryCovers: [String] {
        return galleries.map({ $0.image })
    }
    
    var galleryTitles: [String] {
        return galleries.map({ $0.title ?? "" })
    }
    
    func cellSelected() {
        
    }
}
