//
//  BannerTableViewCell.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/21.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import SDCycleScrollView
import SnapKit

class BannerTableViewCell: UITableViewCell,CellBindViewModelProtocol {

    var galleries:[Gallery]?
    
    @IBOutlet weak var containerView: UIView!
    let imageCycleScroll:SDCycleScrollView = {
        let imageCycleScroll = SDCycleScrollView()
        imageCycleScroll.autoScrollTimeInterval = 4
        imageCycleScroll.backgroundColor = UIColor.white
        imageCycleScroll.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        imageCycleScroll.currentPageDotColor = UIColor.white
        imageCycleScroll.pageDotColor = UIColor(white: 1, alpha: 0.5)
        imageCycleScroll.bannerImageViewContentMode = .scaleAspectFill
        return imageCycleScroll
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageCycleScroll.imageURLStringsGroup = [
            "http://18touch.qiniudn.com/uploads/2014/04/%E6%80%A7%E6%84%9F%E7%BE%8E%E5%A5%B32.jpg",
            "http://pic.qianye88.com/803aa2f053e452f1279995e4fb445b9e.jpg?imageMogr2/thumbnail/850x/quality/100",
            "http://d.5857.com/xglsnymnipadzmbz.120906/005.jpg",
            "http://img3.xiazaizhijia.com/walls/20151118/1440x900_886df4f6547cda7.jpg"]
        imageCycleScroll.titlesGroup = ["美女1","美女2","美女3","美女4"]
        imageCycleScroll.delegate = self
        containerView.addSubview(imageCycleScroll)
        imageCycleScroll.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(with vm: CellViewModelProtocol) {
        let bannerVM = vm as! BannerTableViewCellViewModel
        if bannerVM.galleries.count > 0 {
            galleries = bannerVM.galleries
            imageCycleScroll.imageURLStringsGroup = bannerVM.galleryCovers
            imageCycleScroll.titlesGroup = bannerVM.galleryTitles
        }
    }
}


extension BannerTableViewCell: SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        if let galleries = galleries {
            let gallery = galleries[index]
            NavigationMediator.TopNavigationViewController()?.pushViewController(NavigationMediator.GoodPriceDetailPage(commentableType: gallery.articleType, productId: UInt(gallery.articleId) ?? 0), animated: true)
        }
    }
}
