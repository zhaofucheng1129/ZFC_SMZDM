//
//  Comment.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/24.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation

class Comment: NSObject, Codable {
    var id: UInt = 0
    var userId: UInt = 0
    var username: String = ""
    var content: String = ""
    var coverUrl: String?
    var userAvatar: String?
    var commentableType: String?
    var commentableId: UInt?
    var commentableName: String?
    var commentableCoverUrl: String?
    var parent: Comment?
    var createdAt: Date?
    var floor: UInt = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case username = "username"
        case content = "content"
        case coverUrl = "cover_url"
        case userAvatar = "user_avatar"
        case commentableType = "commentable_type"
        case commentableId = "commentable_id"
        case commentableName = "commentable_name"
        case commentableCoverUrl = "commentable_cover_url"
        case parent = "parent"
        case createdAt = "created_at"
        case floor = "floor"
    }
}
