//
//  MSDRefreshHeader.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/21.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import MJRefresh

class MSDRefreshHeader: MJRefreshHeader {

    var hasRefreshed: Bool = false
    
    var changeText: Bool = false
    
    let textArr: [String] = ["莫愁网上无知己，发篇好文来识君",
                             "好价，是1%的运气加99%的刷新",
                             "好文破万卷，剁手如有神",
                             "罗马不是一天建成的，好价不是一天刷完的",
                             "别弯腰，钱包会掉;别急躁，好物不少",
                             "只是改变命运，好物改善心情"]
    
    let logViewBounds = CGRect(x: 0, y: 0, width: 25, height: 25)
    
    let logView:UIImageView = {
        return UIImageView(image: UIImage(named: "zhi"))
    }()
    
    let circleView: UIImageView = {
        let circleView = UIImageView(image: UIImage(named: "circle"))
        circleView.isHidden = true
        return circleView
    }()
    
    let circleLayer: CAShapeLayer = {
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 25, height: 25))
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.path = path.cgPath
        shapeLayer.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        shapeLayer.strokeEnd = 0
        return shapeLayer
    }()
    
    let textLable: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "848484")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override func prepare() {
        super.prepare()
        
        self.addSubview(self.textLable)
        self.textLable.text = textArr[randomInRange(range: 1..<textArr.count)]
        
        self.logView.addSubview(self.circleView)
        self.logView.layer.addSublayer(self.circleLayer)
        
        self.addSubview(self.logView)
        
        self.hasRefreshed = false
        
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        if !self.changeText {
            self.textLable.text = nextText()
        }
        self.logView.center = CGPoint(x: self.mj_w / 2, y: self.mj_h / 2 + 10)
        self.logView.bounds = logViewBounds
        self.circleView.frame = self.logView.bounds
        self.textLable.sizeToFit()
        self.textLable.frame = CGRect(x: (self.mj_w - self.textLable.width) / 2, y: 5, width: self.textLable.width, height: self.textLable.height)
    }
    
    override var state: MJRefreshState {
        didSet {
            if oldValue == state {
                return
            }
            switch state {
            case .idle:
                self.circleView.isHidden = true
                self.circleLayer.isHidden = false
                break
            case .pulling:
                break
            case .refreshing:
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                self.circleLayer.isHidden = true
                CATransaction.commit()
                
                self.circleView.isHidden = false
                self.circleView.layer.add(createTransformAnimation(), forKey: nil)
                
                self.hasRefreshed = true
            default:
                break
            }
        }
    }
    
    override var pullingPercent: CGFloat {
        didSet {
            if self.hasRefreshed {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                self.circleLayer.strokeEnd = 0
                CATransaction.commit()
                self.hasRefreshed = false
            } else {
                self.circleLayer.strokeEnd = pullingPercent
            }
        }
    }
    
    override func endRefreshing() {
        self.circleView.layer.removeAllAnimations()
        super.endRefreshing()
    }
    
    func createTransformAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 2
        animation.byValue = CGFloat.pi * 2
        animation.fillMode = "forwards"
        animation.repeatCount = 1000
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    func nextText() -> String {
        self.changeText = true
        return textArr[randomInRange(range: 1..<textArr.count)]
    }
    
    func randomInRange(range: Range<Int>) -> Int {
        let count = UInt32(range.upperBound - range.lowerBound)
        return  Int(arc4random_uniform(count)) + range.lowerBound
    }
}
