//
//  UIImageView+Extension.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/24.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation
import SDWebImage

extension UIImageView {
    func msd_setImage(with urlStr: String?) {
//        self.image = UIImage(named: "logo_product_default")
//        if let urlStr = urlStr?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let imageUrl = URL(string: urlStr) {
//            SDWebImageManager.shared().imageDownloader?.downloadImage(with: imageUrl, options: SDWebImageDownloaderOptions(rawValue: 0), progress: nil, completed: { [weak self] (image, data, error, finished) in
//                DispatchQueue.main.async {
//                    if finished, let strongSelf = self {
//                        if let _ = error {
//                            strongSelf.image = UIImage(named: "logo_product_default")
//                        } else {
//                            if let image = image {
//                                strongSelf.image = image
//
//                                let transition = CATransition()
//                                transition.type = kCATransitionFade
//                                transition.duration = 0.3
//                                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//
//                                strongSelf.layer.add(transition, forKey: nil)
//                            }
//                        }
//                    }
//                }
//            })
        if let urlStr = urlStr?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let imageUrl = URL(string: urlStr) {
            self.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "logo_product_default")) { [weak self] (image, error, cacheType, url) in
                if let _ = image, cacheType == SDImageCacheType.none {
                    let transition = CATransition()
                    transition.type = kCATransitionFade
                    transition.duration = 0.3
                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    self?.layer.add(transition, forKey: nil)
                }
            }
        }
    }
}
