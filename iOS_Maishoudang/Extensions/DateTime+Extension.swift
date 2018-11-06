//
//  DateTime+Extension.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/22.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation

extension Date {
    
    func dateTime(format:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "zh_Hans_CN")
        return formatter.string(from: self)
    }
    
    func compareCurrentTime() -> String {
        let currentTime = Date()
        let timeInterval = currentTime.timeIntervalSince(self)
        
        //时间差小于60秒
        if timeInterval < 60 {
            return "\(Int(timeInterval))秒前"
        }
        
        //时间差大于一分钟小于60分钟内
        let mins = Int(timeInterval / 60)
        if mins < 60 {
            return "\(mins)分钟前"
        }
        
        let hours = Int(mins / 60)
        if hours < 24 {
            return "\(hours)小时前"
        }
        
        let days = Int(hours / 24)
        if days < 30 {
            return "\(days)天前"
        }
        
        let months = Int(days / 30)
        if months < 12 {
            return "\(months)月前"
        }
        
        let years = Int(months / 12)
        return "\(years)年前"

    }
}
