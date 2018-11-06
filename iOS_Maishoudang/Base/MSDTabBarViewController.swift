//
//  MSDTabBarViewController.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/19.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import SnapKit
import DeviceKit
import RxSwift
import RxCocoa
import KeychainAccess
//if #available(iOS 11.0, *) {
//
//} else {
//
//}

class MSDTabBarViewController: UITabBarController,UITabBarControllerDelegate {
    
    private let tabBarItemNumber = 5
    
    private var currentSelectIndex = 0
    
    private var bag = DisposeBag()
    
    public let tabBarView: UIView = {
        let tabBarView = UIView()
        tabBarView.backgroundColor = UIColor.white
        return tabBarView
    }()
    private let currentDevice = Device()
    private var tabBarButtons: [UIButton]?
    
    public var tabBarHeight = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
        
        tabBarHeight = 50.0
        
        if currentDevice.isOneOf(Device.allPlusSizedDevices) || currentDevice.isOneOf(Device.allSimulatorPlusSizedDevices) {
            //iPhone Plus
            tabBarHeight = 75
            self.initTabBarButton(normal: "icon_bg_6p_", choose: "icon_bg_act_6p_")
        } else if currentDevice == Device.iPhoneX || currentDevice == Device.simulator(.iPhoneX){
            //iPhoneX
            tabBarHeight = Double(252.0 / UIScreen.main.scale)
            self.initTabBarButton(normal: "icon_bg_X_", choose: "icon_bg_act_X_")
        } else if currentDevice.diagonal == 4.7 || currentDevice.isOneOf(Device.allPads) || currentDevice.isOneOf(Device.allSimulatorPads) {
            //iPhone6
            self.initTabBarButton(normal: "icon_bg_6_", choose: "icon_bg_act_6_")
        } else {
            //iPhone6以下
            self.initTabBarButton(normal: "icon_bg_5_", choose: "icon_bg_act_5_")
        }
        
        
        //添加自定义TabBarView
        self.view.addSubview(tabBarView)
        tabBarView.snp.makeConstraints { (make) in
            make.height.equalTo(tabBarHeight)
            make.left.right.bottom.equalTo(self.view)
        }
        
        //布局按钮
        self.layoutTabBarButton()
        
        
        //注册设备
        if let deviceId = CacheManager.getDeviceId(), !deviceId.isEmpty {
            JPUSHService.setAlias(deviceId, completion: nil, seq: 0)
        } else {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            msdApiProvider.rx.request(.deviceRegisterApi).map(MsdDevice.self, atKeyPath: nil, using: decoder, failsOnEmptyData: false).subscribe(onSuccess: { (device) in
                CacheManager.saveDeviceInfo(device: device)
                CacheManager.saveDeviceId(deviceId: "\(device.id)")
                JPUSHService.setAlias("\(device.id)", completion: nil, seq: 0)
            }) { (error) in
                
            }.disposed(by: bag)
        }
        
        launchAnimation()
    }
    
    //播放启动画面动画
    private func launchAnimation() {
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        if let img = splashImageForOrientation(statusBarOrientation,
                                               size: self.view.bounds.size) {
            //获取启动图片
            let launchImage = UIImage(named: img)
            let launchview = UIImageView(frame: UIScreen.main.bounds)
            launchview.image = launchImage
            //将图片添加到视图上（分两种情况）
            //情况1:没有导航栏
            self.view.addSubview(launchview)
            //情况2:有导航栏
//            let delegate = UIApplication.shared.delegate
//            let mainWindow = delegate?.window
//            mainWindow!!.addSubview(launchview)
            //播放动画效果，完毕后将其移除
            UIView.animate(withDuration: 1, delay: 1.5, options: .beginFromCurrentState,
                           animations: {
                            launchview.alpha = 0.0
                            launchview.layer.transform = CATransform3DScale(
                                CATransform3DIdentity, 1.5, 1.5, 1.0)
            }) { (finished) in
                launchview.removeFromSuperview()
            }
        }
    }
    
    //获取启动图片名（根据设备方向和尺寸）
    func splashImageForOrientation(_ orientation: UIInterfaceOrientation, size: CGSize)-> String?{
        //获取设备尺寸和方向
        var viewSize = size
        var viewOrientation = "Portrait"
        
        if UIInterfaceOrientationIsLandscape(orientation) {
            viewSize = CGSize(width: size.height, height: size.width)
            viewOrientation = "Landscape"
        }
        //遍历资源库中的所有启动图片，找出符合条件的
        if let imagesDict = Bundle.main.infoDictionary {
            if let imagesArray = imagesDict["UILaunchImages"] as? [[String: String]] {
                for dict in imagesArray {
                    if let sizeString = dict["UILaunchImageSize"],
                        let imageOrientation = dict["UILaunchImageOrientation"] {
                        let imageSize = CGSizeFromString(sizeString)
                        if imageSize.equalTo(viewSize)
                            && viewOrientation == imageOrientation {
                            if let imageName = dict["UILaunchImageName"] {
                                return imageName
                            }
                        }
                    }
                }
            }
        }
        return nil
    }
    
    //初始化TabBar按钮
    func initTabBarButton(normal:String, choose:String) {
        tabBarButtons = [UIButton]()
        for index in 1...tabBarItemNumber {
            let button = UIButton(type: .custom)
            //当前选择的按钮
            if (index - 1) == currentSelectIndex {
                button.setImage(UIImage(named: "\(choose)\(index)"), for: .normal)
            } else {
                button.setImage(UIImage(named: "\(normal)\(index)"), for: .normal)
            }
            button.adjustsImageWhenHighlighted = false
            _ = button.rx.tap.bind { [weak self] in
                if let strongSelf = self {
                    strongSelf.selectedIndex = index - 1
                    
                    if let tabBarButtons = strongSelf.tabBarButtons {
                        var button = tabBarButtons[strongSelf.currentSelectIndex]
                        button.setImage(UIImage(named: "\(normal)\(strongSelf.currentSelectIndex + 1)"), for: .normal)
                        button = tabBarButtons[index - 1]
                        button.setImage(UIImage(named: "\(choose)\(index)"), for: .normal)
                    }
                    
                    strongSelf.currentSelectIndex = index - 1
                }
            }
            tabBarButtons!.append(button)
        }
    }
    
    
    
    //布局TabBar按钮
    func layoutTabBarButton() {
        
        guard let tabBarButtons = tabBarButtons, tabBarButtons.count > 0 else {
            return
        }
        
        var firstButton:UIButton!
        var alignLeftItem = tabBarView.snp.left
        
        for (index, button) in tabBarButtons.enumerated() {
            tabBarView.addSubview(button)
            
            // 第一个button左边固定在父容器的左侧，不设置宽度
            if index == 0 {
                firstButton = button
                button.snp.makeConstraints({ (b) in
                    b.height.equalToSuperview()
                    b.left.equalTo(alignLeftItem)
                    b.top.equalToSuperview()
                })
                alignLeftItem = button.snp.right
                // 之后的每一个button（除了最后一个）：
                // 左边固定在上一个button的右侧
                // 宽度设置与第一个button相等
            } else if index < tabBarButtons.count - 1 {
                button.snp.makeConstraints({ (b) in
                    b.width.equalTo(firstButton)
                    b.height.equalToSuperview()
                    b.left.equalTo(alignLeftItem)
                    b.top.equalToSuperview()
                })
                alignLeftItem = button.snp.right
                // 最后一个button：
                // 左边固定在倒数第二个button的右侧
                // 右边固定在父容器的右边
                // 宽度设置为与第一个button相等
            } else {
                button.snp.makeConstraints({ (b) in
                    b.width.equalTo(firstButton)
                    b.height.equalToSuperview()
                    b.left.equalTo(alignLeftItem)
                    b.right.equalTo(tabBarView.snp.right)
                    b.top.equalToSuperview()
                })
            }
        }
    }
}
