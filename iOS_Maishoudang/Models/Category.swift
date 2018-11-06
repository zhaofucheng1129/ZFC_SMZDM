//
//  Category.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/30.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation

struct Category: Codable {
    var id: UInt
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
