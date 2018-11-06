//
//  Device.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/8/3.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

class MsdDevice: NSObject, Codable, NSCoding {
    var id: UInt = 0
    var uuid: String = ""
    var osType: String = ""
    var userId: UInt?
    var subscribeBugPrice: Bool = true
    var subscribeBestPrice: Bool = true
    var subscribeNotice: Bool = true
    var subscribeHot: Bool = true
    var createdAt: Date?
    var updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case uuid
        case osType = "os_type"
        case userId = "user_id"
        case subscribeBugPrice = "subscribe_bug_price"
        case subscribeBestPrice = "subscribe_best_price"
        case subscribeNotice = "subscribe_notice"
        case subscribeHot = "subscribe_hot"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(uuid, forKey: "uuid")
        aCoder.encode(osType, forKey: "osType")
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(subscribeBugPrice, forKey: "subscribeBugPrice")
        aCoder.encode(subscribeBestPrice, forKey: "subscribeBestPrice")
        aCoder.encode(subscribeNotice, forKey: "subscribeNotice")
        aCoder.encode(subscribeHot, forKey: "subscribeHot")
        aCoder.encode(createdAt, forKey: "createdAt")
        aCoder.encode(updatedAt, forKey: "updatedAt")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = UInt(aDecoder.decodeInt64(forKey: "id"))
        self.uuid = aDecoder.decodeObject(forKey: "uuid") as! String
        self.osType = aDecoder.decodeObject(forKey: "osType") as! String
        self.userId = UInt(aDecoder.decodeInt64(forKey: "userId"))
        self.subscribeBugPrice = aDecoder.decodeBool(forKey: "subscribeBugPrice")
        self.subscribeBestPrice = aDecoder.decodeBool(forKey: "subscribeBestPrice")
        self.subscribeNotice = aDecoder.decodeBool(forKey: "subscribeNotice")
        self.subscribeHot = aDecoder.decodeBool(forKey: "subscribeHot")
        self.createdAt = aDecoder.decodeObject(forKey: "createdAt") as? Date
        self.updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? Date
    }
}
