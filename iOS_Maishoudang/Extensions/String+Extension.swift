//
//  String+Extension.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/24.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation

extension String {
    func contentHtmlConvert() -> String {
        return "<html><meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"/><head><style type=\"text/css\">.item{border-color:#EF473A} .item:first-child{border-top:0}.popover .item:last-child{border-bottom:0} .item-body{border-width:0;padding-top:0}  img { max-width:95%;height:auto;} .rich_media_area_primary { position: relative; padding: 10px 15px 15px; background-color: #fff; } * {margin: 0;padding: 0;outline: 0;}.detail-image {padding-bottom: 10px;background: #fff;width: 100%;overflow: hidden;text-align: center;}div {display: block;}p {line-height: 1.8em;margin-bottom: 16px;color: #444;word-wrap: break-word;word-break: break-all;}a, a:hover {text-decoration: none;}a {color: #5188a6;cursor: pointer;}</style> </head><body><div class=\"item item-body\"><div id=\"img-content\" class=\"rich_media_area_primary\"><div >\(self.filterImageHtml())</div></div></div></body></html>"
        
        
    }
    
    func formatContent() -> NSMutableAttributedString {
        let content = self
        let tempContent = content.filterHTML()
        let contentText = NSMutableAttributedString(string: tempContent)
        contentText.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0), range: NSMakeRange(0, tempContent.count))
        contentText.addAttribute(.foregroundColor, value: UIColor(hexString: "333333")!, range: NSMakeRange(0, tempContent.count))
        
        do {
            let regex = try NSRegularExpression(pattern: "@.*?</a>", options: .caseInsensitive)
            let res = regex.matches(in: content, options: .init(rawValue: 0), range: NSMakeRange(0, content.count))
            // 输出结果
            for checkingRes in res {
                let result = (content as NSString).substring(with: checkingRes.range)
                
                if let range = tempContent.range(of: result.filterHTML()) {
                    contentText.addAttribute(.foregroundColor, value: UIColor(hexString: "F43459")!, range: NSRange(range, in: tempContent))
                }
            }
            
            return contentText
        } catch {
            return NSMutableAttributedString(string: tempContent)
        }
    }
    
    func filterImageHtml() -> String {
        var html = self.replacingOccurrences(of: "<p><br></p>", with: "")
        let scanner = Scanner(string: html)
        var imageHtml:NSString?
        while !scanner.isAtEnd {
            scanner.scanUpTo("<img", into: nil)
            if scanner.scanUpTo("</p>", into: &imageHtml) {
                if let tempImage = imageHtml as String? {
                    html = html.replacingOccurrences(of: tempImage, with: "<div class=\"detail-image\">\(tempImage)</div>")
                }
            }
        }
        return html
    }
    
    func filterHTML() -> String {
        var content = self
        let scanner = Scanner(string: self)
        var text:NSString?
        while !scanner.isAtEnd {
            scanner.scanUpTo("<", into: nil)
            scanner.scanUpTo(">", into: &text)
            if let scanText = text as String? {
                content = content.replacingOccurrences(of: "\(scanText)>", with: "")
            }
        }
        return content
    }

}
