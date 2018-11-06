//
//  BottomOperationView.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/21.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailBottomOperationView: UIView {

    private var bag = DisposeBag()
    
    @IBOutlet weak var zan: UILabel!
    @IBOutlet weak var favorite: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    @IBOutlet weak var zanIcon: UIImageView!
    @IBOutlet weak var collectIcon: UIImageView!
    
    
    @IBOutlet weak var zanButton: UIButton!
    @IBOutlet weak var collectButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var buyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func bindViewModel() {
        
    }
    
    func playZanAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.zanIcon.alpha = 0
            self.zanIcon.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1)
        }) { (finished) in
            self.zanIcon.alpha = 1
            self.zanIcon.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            self.zanIcon.image = UIImage(named: "IMG_YCDetail_yizanPress")
        }
    }
    
    func playCollectAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.collectIcon.alpha = 0
            self.collectIcon.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1)
        }) { (finished) in
            self.collectIcon.alpha = 1
            self.collectIcon.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            self.collectIcon.image = UIImage(named: "IMG_BKDetail_CollectionSelected")
        }
    }
}
