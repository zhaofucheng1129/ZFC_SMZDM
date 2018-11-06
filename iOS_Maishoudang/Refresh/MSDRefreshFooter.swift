//
//  MSDRefreshFooter.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/31.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

class MSDRefreshFooter: MJRefreshBackFooter {
    
    var hasRefreshed: Bool = false
    
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
    
    override func prepare() {
        super.prepare()
        
        self.logView.addSubview(self.circleView)
        self.logView.layer.addSublayer(self.circleLayer)
        
        self.addSubview(self.logView)
        
        self.hasRefreshed = false
        
    }
    
    override func placeSubviews() {
        super.placeSubviews()

        self.logView.center = CGPoint(x: self.mj_w / 2, y: self.mj_h / 2)
        self.logView.bounds = logViewBounds
        self.circleView.frame = self.logView.bounds
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
}
