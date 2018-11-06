//
//  ProductDetail.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/24.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation

struct ProductDetail: Codable {
    let id: UInt
    let name: String
    let type: String
    let authorUser: String?
    let createdAt: Date?
    let publishedAt: Date
    let content: String
    let commentsCount: UInt
    let favoritesCount: UInt
    let author: String
    let authorAvatar: String
    let agreeCount: UInt
    let disagreeCount: UInt
    let merchantName: String?
    let articleLink: String?
    let purchaseLink: String?
    let subtitle: String?
    let freeAgent: String?
    let comments: [Comment]?
    let mediumCover: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case authorUser = "author_user"
        case createdAt = "created_at"
        case publishedAt = "published_at"
        case content
        case commentsCount = "comments_count"
        case favoritesCount = "favorites_count"
        case author
        case authorAvatar = "author_avatar"
        case agreeCount = "agree_count"
        case disagreeCount = "disagree_count"
        case merchantName = "merchant_name"
        case articleLink = "article_link"
        case purchaseLink = "purchase_link"
        case subtitle
        case freeAgent = "free_agent"
        case comments
        case mediumCover = "medium_cover"
    }
}
