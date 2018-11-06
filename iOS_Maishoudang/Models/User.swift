//
//  User.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/8/1.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

class User: NSObject, Codable, NSCoding {
    
    var id: UInt = 0
    var username: String?
    var email: String?
    var credit: Int = 0
    var unreadNoticesCount: UInt = 0
    var authorizeToken: String?
    var avatarUrl: String?
    var createdAt: Date?
    var deviceId: UInt = 0
    var deviceUuid: String?
    var deviceOsType: String?
    var subscribeBestPrice: Bool = true
    var subscribeNotice: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case credit
        case unreadNoticesCount = "unread_notices_count"
        case authorizeToken = "authorize_token"
        case avatarUrl = "avatar_url"
        case createdAt = "created_at"
        case deviceId = "device_id"
        case deviceUuid = "device_uuid"
        case deviceOsType = "device_os_type"
        case subscribeBestPrice = "subscribe_best_price"
        case subscribeNotice = "subscribe_notice"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(credit, forKey: "credit")
        aCoder.encode(unreadNoticesCount, forKey: "unreadNoticesCount")
        aCoder.encode(authorizeToken, forKey: "authorizeToken")
        aCoder.encode(avatarUrl, forKey: "avatarUrl")
        aCoder.encode(createdAt, forKey: "createdAt")
        aCoder.encode(deviceId, forKey: "deviceId")
        aCoder.encode(deviceUuid, forKey: "deviceUuid")
        aCoder.encode(deviceOsType, forKey: "deviceOsType")
        aCoder.encode(subscribeBestPrice, forKey: "subscribeBestPrice")
        aCoder.encode(subscribeNotice, forKey: "subscribeNotice")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! UInt
        self.username = aDecoder.decodeObject(forKey: "username") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        self.credit = Int(aDecoder.decodeInt64(forKey: "credit"))
        self.unreadNoticesCount = aDecoder.decodeObject(forKey: "unreadNoticesCount") as! UInt
        self.authorizeToken = aDecoder.decodeObject(forKey: "authorizeToken") as? String
        self.avatarUrl = aDecoder.decodeObject(forKey: "avatarUrl") as? String
        self.createdAt = aDecoder.decodeObject(forKey: "createdAt") as? Date
        self.deviceId = aDecoder.decodeObject(forKey: "deviceId") as! UInt
        self.deviceUuid = aDecoder.decodeObject(forKey: "deviceUuid") as? String
        self.deviceOsType = aDecoder.decodeObject(forKey: "deviceOsType") as? String
        self.subscribeBestPrice = aDecoder.decodeBool(forKey: "subscribeBestPrice")
        self.subscribeNotice = aDecoder.decodeBool(forKey: "subscribeNotice")
    }
    
    //    "id": 14907,
    //    "username": "kentno1",
    //    "email": "kentno1@hotmail.com",
    //    "credit": 12,
    //    "unread_notices_count": 4,
    //    "authorize_token": "dd605630f71fdd11244bb79def6ab38d",
    //    "avatar_url": "http://images.maishoudang.com/production/uploads/picture/image/53993/1462420220.jpg!small",
    //    "created_at": "2016-03-07T17:12:56.000+08:00",
    //    "device_id": 13219,
    //    "device_uuid": "0bb8f6ce-99f1-437a-8809-174eaa94eea2",
    //    "device_os_type": null,
    //    "subscribe_best_price": true,
    //    "subscribe_notice": true
}
