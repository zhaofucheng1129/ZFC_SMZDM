//
//  MSDBaseViewController.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/19.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import PKHUD

class MSDBaseViewController: UIViewController {

    @IBInspectable var showSearchBar:Bool = false
    
    public var hidesTabBarWhenPushed: Bool = false
    public var hidesBackButton: Bool = true {
        didSet {
            backButton.isHidden = hidesBackButton
        }
    }
    
    //屏幕截图
    public var snapShotView: UIView?
    
    private var bag = DisposeBag()
    
    /// 自定义状态栏背景
    public let statusBar: UIView = {
        let statusView = UIView()
        statusView.backgroundColor = UIColor.white
        return statusView
    }()
    
    /// 自定义导航栏
    public var navigationBar: UIView = UIView()
    
    /// 标题Label
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "222222")
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    /// 返回按钮
    public let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon_back")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    public var tabBarVC: MSDTabBarViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        tabBarVC = self.tabBarController as? MSDTabBarViewController
        
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(-UIApplication.shared.statusBarFrame.height)
            } else {
                make.top.equalTo(self.topLayoutGuide.snp.top)
            }
            make.height.equalTo(UIApplication.shared.statusBarFrame.height)
        }
        
        //添加导航栏
        if self.showSearchBar {
            let searchNavigationBarView = Bundle.main.loadNibNamed("SearchNavigationBarView", owner: nil, options: nil)?.last as! SearchNavigationBarView
            
            //分类按钮
            searchNavigationBarView.categoryBtn.rx.tap.bind {
                HUD.flash(.label("待实现"), delay: 1)
            }.disposed(by: bag)
            
            searchNavigationBarView.moreBtn.rx.tap.bind {
                let background = UIControl(frame: CGRect.zero)
                background.backgroundColor = UIColor.black
                background.alpha = 0
                let delegate = UIApplication.shared.delegate
                let mainWindow = delegate?.window
                mainWindow!!.addSubview(background)
                background.snp.makeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
                
                let menuView = Bundle.main.loadNibNamed("NavigationBarMenuView", owner: nil, options: nil)?.last as! NavigationBarMenuView
                mainWindow!!.addSubview(menuView)
                menuView.snp.makeConstraints({ (make) in
                    make.right.equalToSuperview().offset(-15)
                    make.top.equalTo(searchNavigationBarView.snp.bottom).offset(-10)
                    make.size.equalTo(CGSize(width: 1, height: 1))
                })
                
                menuView.superview?.layoutIfNeeded()
                
                UIView.animate(withDuration: 0.2, animations: {
                    background.alpha = 0.3
                    menuView.snp.updateConstraints({ (make) in
                        make.size.equalTo(CGSize(width: 100, height: 168))
                    })
                    menuView.superview?.layoutIfNeeded()
                })
                
                _ = background.rx.controlEvent(.touchUpInside).bind {
                    UIView.animate(withDuration: 0.2, animations: {
                        background.alpha = 0
                        menuView.snp.updateConstraints({ (make) in
                            make.size.equalTo(CGSize(width: 1, height: 1))
                        })
                        menuView.superview?.layoutIfNeeded()
                    }, completion: { (finished) in
                        background.removeFromSuperview()
                        menuView.removeFromSuperview()
                    })
                }
                
                _ = NotificationCenter.default.rx.notification(Notification.Name(rawValue: "NavMenuSelectItem")).subscribe(onNext: { (notification) in
                    UIView.animate(withDuration: 0.2, animations: {
                        background.alpha = 0
                        menuView.snp.updateConstraints({ (make) in
                            make.size.equalTo(CGSize(width: 1, height: 1))
                        })
                        menuView.superview?.layoutIfNeeded()
                    }, completion: { (finished) in
                        background.removeFromSuperview()
                        menuView.removeFromSuperview()
                    })
                })
                
            }.disposed(by: bag)            
            
            navigationBar = searchNavigationBarView
            self.view.insertSubview(navigationBar, belowSubview: statusBar)
            navigationBar.snp.makeConstraints { (make) in
                make.top.equalTo(statusBar.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(44)
            }
            
        } else {
            navigationBar = UIView()
            navigationBar.backgroundColor = UIColor.white
            self.view.insertSubview(navigationBar, belowSubview: statusBar)
            navigationBar.snp.makeConstraints { (make) in
                make.top.equalTo(statusBar.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(44)
            }
        }
        
        //添加标题
        navigationBar.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (label) in
            label.center.equalTo(navigationBar.snp.center)
        }
        
        //添加返回按钮
        navigationBar.addSubview(backButton)
        backButton.isHidden = hidesBackButton
        backButton.snp.makeConstraints { (btn) in
            btn.size.equalTo(CGSize(width: 45, height: 30))
            btn.left.equalToSuperview().offset(12)
            btn.centerY.equalToSuperview()
        }
        
        backButton.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
