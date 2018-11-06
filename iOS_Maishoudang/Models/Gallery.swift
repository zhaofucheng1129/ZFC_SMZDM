//
//  Gallerie.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/21.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation

struct Gallery: Codable {
    let id: UInt
    let title: String?
    let subtitle: String?
    let image: String
    let createdAt: Date
    let url: URL
    let articleId: String
    let articleType: recommendType
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case image
        case createdAt = "created_at"
        case url
        case articleId = "article_id"
        case articleType = "article_type"
    }
}
