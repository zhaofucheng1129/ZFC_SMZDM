//
//  MainHeaderTableViewCell.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/27.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import SwifterSwift
import RxSwift
import RxCocoa

class MainHeaderTableViewCell: UITableViewCell, CellBindViewModelProtocol {
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    private var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.roundCorners(.allCorners, radius: userImage.width / 2)
        userName.text = "点击登陆"
        
        if let user = CacheManager.getUserInfo() {
            userImage.msd_setImage(with: user.avatarUrl)
            backgroundImage.msd_setImage(with: user.avatarUrl)
            userName.text = user.username ?? ""
        }
    }
    
    func bind(with vm: CellViewModelProtocol) {
        CacheManager.shared.currentUser.subscribe(onNext: { [weak self] (user) in
            if let strongSelf = self {
                if let user = user {
                    strongSelf.userImage.msd_setImage(with: user.avatarUrl)
                    strongSelf.backgroundImage.msd_setImage(with: user.avatarUrl)
                    strongSelf.userName.text = user.username ?? ""
                } else {
                    strongSelf.userName.text = "点击登陆"
                    strongSelf.backgroundImage.image = UIImage(named: "icon_user_cover")
                    strongSelf.userImage.image = UIImage(named: "icon_user_cover")
                }
            }
        }).disposed(by: bag)
    }
}
