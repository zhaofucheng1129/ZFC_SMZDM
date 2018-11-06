//
//  Product.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/22.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation

struct Product: Codable {

    let namePinyin: String?
    let id: UInt
    let createdAt: Date
    let author: String?
    let name: String?
    let subtitle: String?
    let image: String?
    let publishedAt: Date
    let merchantName: String?
    let agreeCount: UInt = 0
    let purchaseLink: String?
    let disagreeCount: UInt = 0
    let commentsCount: UInt
    let favoritesCount: UInt
    let type: recommendType
    
    enum CodingKeys: String, CodingKey {
        case namePinyin = "name_pinyin"
        case id
        case createdAt = "created_at"
        case author
        case name
        case subtitle
        case image
        case publishedAt = "published_at"
        case merchantName = "merchant_name"
        case agreeCount = "agree_count"
        case purchaseLink = "purchase_link"
        case disagreeCount = "disagree_count"
        case commentsCount = "comments_count"
        case favoritesCount = "favorites_count"
        case type
    }
}
