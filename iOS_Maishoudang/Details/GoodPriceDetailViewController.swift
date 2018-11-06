//
//  GoodPriceDetailViewController.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/21.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import WebKit
import PKHUD
import JXPhotoBrowser
import Photos

class GoodPriceDetailViewController: MSDBaseViewController {
    
    private weak var showingBrowser: PhotoBrowser?
    
    var detailImages: [String]?
    
    private var bag = DisposeBag()
    
    private let goodPriceVM: ProductDetailViewControllerViewModel
    
    private var coverHeight: CGFloat = 0
    private var detailInfoHeight: CGFloat = 148
    private var headerView: UIView?
    private let tableView : UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init(vm: ProductDetailViewControllerViewModel) {
        self.goodPriceVM = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "详情"
        navigationBar.alpha = 0
        
        view.backgroundColor = UIColor.white
        
        coverHeight = view.width * 216 / 375
        
        view.insertSubview(tableView, belowSubview: navigationBar)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(statusBar.snp.bottom)
        }
        
        tableView.register(UINib(nibName: CellReuseIdentifierManager.NormalCommentCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.NormalCommentCellId)
        tableView.register(UINib(nibName: CellReuseIdentifierManager.ReplyCommentCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.ReplyCommentCellId)
        tableView.register(UINib(nibName: CellReuseIdentifierManager.CommentHeaderCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.CommentHeaderCellId)
        tableView.estimatedRowHeight = 0
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let bottomView = Bundle.main.loadNibNamed("DetailBottomOperationView", owner: nil, options: nil)?.last as? DetailBottomOperationView
        
        if let bottomView = bottomView {
            view.addSubview(bottomView)
            bottomView.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(tableView.snp.bottom)
                make.height.equalTo(50)
                
                if #available(iOS 11.0, *) {
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                } else {
                    make.bottom.equalTo(view.snp.bottom)
                }
            }
            
            bottomView.commentButton.rx.tap.bind { [weak self] in
                _ = self?.goodPriceVM.cellSelectedCommand.subscribe()
            }.disposed(by: bag)
            
            bottomView.zanButton.rx.tap.bind { [weak self] in
                self?.goodPriceVM.requestAgree(complete: {
                    bottomView.playZanAnimation()
                })
            }.disposed(by: bag)
            
            bottomView.collectButton.rx.tap.bind { [weak self] in
                self?.goodPriceVM.requestSetFavorite(complete: {
                    bottomView.playCollectAnimation()
                })
            }.disposed(by: bag)
            
            bottomView.buyButton.rx.tap.bind { [weak self] in
                if let freeAgent = self?.goodPriceVM.productDetail?.freeAgent, freeAgent != "" {
                    
                } else {
                    if let purchaseLink = self?.goodPriceVM.productDetail?.purchaseLink {
                        let page = AlibcTradePageFactory.page(purchaseLink)
                        
                        let showParam = AlibcTradeShowParams()
                        showParam.openType = .auto
                        showParam.isNeedPush = true
                        
                        if purchaseLink.contains("tmall") || purchaseLink.contains("taobao") {
                            if let merchantName = self?.goodPriceVM.productDetail?.merchantName, merchantName.contains("天猫") {
                                showParam.openType = .native
                                showParam.linkKey = "tmall_scheme"
                            } else if let merchantName = self?.goodPriceVM.productDetail?.merchantName, merchantName.contains("淘宝") {
                                showParam.openType = .native
                                showParam.linkKey = "taobao_scheme"
                            }
                        }
                        
                        let productWebVC = ProductWebViewController()
                        let ret = AlibcTradeSDK.sharedInstance().tradeService().show(productWebVC, webView: productWebVC.webView, page: page, showParams: showParam, taoKeParams: nil, trackParam: nil, tradeProcessSuccessCallback: { (result) in
                            
                        }) { (error) in
                            
                        }
                        
                        //返回1,说明h5打开,否则不应该展示页面
                        if ret == 1 {
                            self?.navigationController?.pushViewController(productWebVC, animated: true)
                        }
                    }
                }
            }.disposed(by: bag)
            
        } else {
            tableView.snp.makeConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom)
            }
        }
        
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: coverHeight))
        
        let coverView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.width, height: coverHeight))
        coverView.backgroundColor = UIColor.white
        //coverView.msd_setImage(with: "http://img.255244.com/ddapi/img/20160709101658244.jpg?imageMogr2/quality/90")
        coverView.contentMode = .scaleAspectFill
        coverView.clipsToBounds = true
        headerView?.addSubview(coverView)
        
        let detailInfoView = UIView(frame: CGRect(x: 0, y: coverHeight, width: view.width, height: detailInfoHeight))
        detailInfoView.backgroundColor = UIColor.white
        headerView?.addSubview(detailInfoView)
        
        let infoView = Bundle.main.loadNibNamed("GoodPriceDetailHeaderView", owner: nil, options: nil)?.last as? GoodPriceDetailHeaderView
        
        if infoView != nil {
            detailInfoView.addSubview(infoView!)
            infoView!.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
        let webView = WKWebView(frame: CGRect(x: 16, y: coverHeight + detailInfoHeight, width: view.width - 32, height: 0))
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        headerView?.addSubview(webView)
        
        tableView.beginUpdates()
        tableView.tableHeaderView = headerView
        tableView.endUpdates()
        
        let customBackButton = UIButton(type: .system)
        customBackButton.setImage(backButton.image(for: .normal), for: .normal)
        customBackButton.contentHorizontalAlignment = backButton.contentHorizontalAlignment
        view.addSubview(customBackButton)
        customBackButton.snp.makeConstraints { (make) in
            make.center.equalTo(backButton)
            make.size.equalTo(backButton)
        }
        customBackButton.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: bag)
        
        tableView.rx.contentOffset.bind { [weak self] (contentOffset) in
            self?.navigationBar.alpha = contentOffset.y / 150.0
        }.disposed(by: bag)
        
        
        goodPriceVM.requestNewData { [weak self] in
            if let strongSelf = self, let productDetail = strongSelf.goodPriceVM.productDetail {
                let content = productDetail.content.contentHtmlConvert()
//                if #available(iOS 9.0, *) {
//                    webView.load(content.data(using: .utf8)!, mimeType: "text/html", characterEncodingName: "utf-8", baseURL: URL(string: "http://www.maishoudang.com")!)
//                } else {
                    webView.loadHTMLString(content, baseURL: nil)
//                }
                
                coverView.msd_setImage(with: productDetail.mediumCover)
                
                if let infoView = infoView {
                    infoView.titleLabel.text = productDetail.name
                    infoView.shortTitleLabel.text = productDetail.subtitle
                    let time = productDetail.publishedAt.dateTime(format: "MM-dd HH:mm")
                    infoView.sourceLabel.text = "\(productDetail.merchantName ?? "") | \(time) | 爆料人：\(productDetail.author)"
                }
                
                if let bottomView = bottomView {
                    bottomView.zan.text = "\(productDetail.agreeCount)"
                    bottomView.favorite.text = "\(productDetail.favoritesCount)"
                    bottomView.comment.text = "\(productDetail.commentsCount)"
                }
            }
        }
        
        webView.scrollView.rx.observe(type(of: webView.scrollView.contentSize), "contentSize").distinctUntilChanged().subscribe(onNext: { [weak self] (size) in
            if let height = size?.height, height > 0 {
                DispatchQueue.main.async {
                    if let strongSelf = self {
                        webView.frame = CGRect(x: 0, y: strongSelf.coverHeight + strongSelf.detailInfoHeight,
                                               width: strongSelf.view.width, height: height)
                        strongSelf.headerView?.frame = CGRect(x: 0, y: 0, width: strongSelf.view.width,
                                                              height: strongSelf.coverHeight + strongSelf.detailInfoHeight + height)
                        //                        strongSelf.tableView.beginUpdates()
                        strongSelf.tableView.tableHeaderView = strongSelf.headerView
                        strongSelf.tableView.reloadData()
                        //                        strongSelf.tableView.endUpdates()
                    }
                }
            }
        }).disposed(by: bag)
    }
    
    /// 逐个属性配置
    private func openPhotoBrowserWithInstanceMethod(index: Int) {
        // 创建图片浏览器
        let browser = PhotoBrowser()
        // 提供两种动画效果：缩放`.scale`和渐变`.fade`。
        // 如果希望`scale`动画不要隐藏关联缩略图，可使用`.scaleNoHiding`。
        browser.animationType = .fade
        // 浏览器协议实现者
        browser.photoBrowserDelegate = self
        // 装配页码指示器插件，提供了两种PageControl实现，若需要其它样式，可参照着自由定制
        // 光点型页码指示器
        browser.plugins.append(DefaultPageControlPlugin())
        // 数字型页码指示器
        browser.plugins.append(NumberPageControlPlugin())
        // 装配附加视图插件
//        setupOverlayPlugin(on: browser, index: index)
        // 指定打开图片组中的哪张
        browser.originPageIndex = index
        // 展示
        browser.show()
        showingBrowser = browser
        
        // 可主动关闭图片浏览器
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
         browser.dismiss(animated: false)
         }*/
    }
}

extension GoodPriceDetailViewController: PhotoBrowserDelegate {
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        if let detailImages = detailImages {
            return detailImages.count
        }
        return 0
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailImageForIndex index: Int) -> UIImage? {
        return nil
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, highQualityUrlForIndex index: Int) -> URL? {
        if let urls = self.detailImages {
            return URL(string: urls[index])
        }
        return nil
    }
    
    /// 长按图片。你可以在此处得到当前图片，并可以做弹窗，保存图片等操作
    func photoBrowser(_ photoBrowser: PhotoBrowser, didLongPressForIndex index: Int, image: UIImage) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveImageAction = UIAlertAction(title: "保存图片", style: .default) { (_) in
//            print("保存图片：\(image)")
            
//            let photoStatus = PHPhotoLibrary.authorizationStatus()
            
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status {
                case .authorized: //已经获取权限
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAsset(from: image)
                    }) { (isSuccess: Bool, error: Error?) in
                        DispatchQueue.main.async {
                            if isSuccess {
                                HUD.flash(.labeledSuccess(title: "成功", subtitle: "保存成功"))
                            } else{
                                print("保存失败：", error!.localizedDescription)
                            }
                        }
                    }
                default:
                    DispatchQueue.main.async {
                        HUD.flash(.labeledError(title: "错误", subtitle: "未获得访问相册权限"),delay: 1.0)
                    }
                }
            })
        }
        /*let loadRawAction = UIAlertAction(title: "查看原图", style: .default) { (_) in
         // 加载长按的原图
         photoBrowser.loadRawImage(at: index)
         }*/
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        actionSheet.addAction(saveImageAction)
        actionSheet.addAction(cancelAction)
        photoBrowser.present(actionSheet, animated: true, completion: nil)
    }
}

extension GoodPriceDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //加载页面完成
        
        //js方法遍历图片添加点击事件 返回图片个数
        /*这块我着重说几句
         逻辑:
         1.遍历获取全部的图片;
         2.生成一个Srting为所有图片的拼接,拼接时拿到所处数组下标;
         3.为图片添加点击事件,并添加数组所处下标
         注意点:
         1.如果仅仅拿到url而无下标的话,网页中如果有多张相同地址的图片 则会发生位置错乱
         2.声明时不要用 var yong let  不然方法添加的i 永远是length的值
         */
        let jsGetImages = """
            function getImages(){
                var objs = document.getElementsByTagName(\"img\");
                var imgScr = '';
                for(let i=0;i<objs.length;i++){
                    imgScr = imgScr + objs[i].src +'L+Q+X';
                    objs[i].onclick=function(){
                        document.location="myweb:imageClick:"+this.src + 'LQXindex' + i;
                    };
                };
                return imgScr;
            };
        """
        webView.evaluateJavaScript(jsGetImages) { (result, error) in
            
        }
        
        webView.evaluateJavaScript("getImages()") { [weak self] (result, error) in
            if error == nil, let imageStr = result as? String {
                var allUrlArray = imageStr.components(separatedBy: "L+Q+X")
                if allUrlArray.count >= 2 {
                    allUrlArray.removeLast()
                    self?.detailImages = allUrlArray
                }
            }
        }
        
//        webView.evaluateJavaScript("document.body.scrollHeight") { [weak self] (result, error) in
//            if error == nil {
//
//            }
//        }
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let requestString = navigationAction.request.url?.absoluteString
        if let requestString = requestString, requestString.hasPrefix("myweb:imageClick:") {
            let idx = requestString.index(requestString.startIndex, offsetBy: "myweb:imageClick:".count)
            let imageUrl = String(requestString[idx...])
            if let imageIndex = imageUrl.components(separatedBy: "LQXindex").last, let i = Int(imageIndex) {
                openPhotoBrowserWithInstanceMethod(index: i)
            }
        }
        
        if navigationAction.navigationType == .linkActivated, let requestString = requestString {
            let page = AlibcTradePageFactory.page(requestString)
            
            let showParam = AlibcTradeShowParams()
            showParam.openType = .auto
            showParam.isNeedPush = true
            
            if requestString.contains("tmall") || requestString.contains("taobao") {
                if let merchantName = self.goodPriceVM.productDetail?.merchantName, merchantName.contains("天猫") {
                    showParam.openType = .native
                    showParam.linkKey = "tmall_scheme"
                } else if let merchantName = self.goodPriceVM.productDetail?.merchantName, merchantName.contains("淘宝") {
                    showParam.openType = .native
                    showParam.linkKey = "taobao_scheme"
                }
            }
            
            let productWebVC = ProductWebViewController()
            let ret = AlibcTradeSDK.sharedInstance().tradeService().show(productWebVC, webView: productWebVC.webView, page: page, showParams: showParam, taoKeParams: nil, trackParam: nil, tradeProcessSuccessCallback: { (result) in
                
            }) { (error) in
                
            }
            
            //返回1,说明h5打开,否则不应该展示页面
            if ret == 1 {
                self.navigationController?.pushViewController(productWebVC, animated: true)
            }
        }
        
        decisionHandler(.allow)
    }
}

extension GoodPriceDetailViewController: WKUIDelegate {
    
}

extension GoodPriceDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodPriceVM.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = self.goodPriceVM.dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellReuseIdentifier(), for: indexPath)
        return cell
    }
}

extension GoodPriceDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellViewModel = self.goodPriceVM.dataSource[indexPath.row]
        (cell as! CellBindViewModelProtocol).bind(with: cellViewModel)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = self.goodPriceVM.dataSource[indexPath.row]
        if cellViewModel.cellHeight() > 0 {
            return cellViewModel.cellHeight()
        } else {
            return tableView.fd_heightForCell(withIdentifier: cellViewModel.cellReuseIdentifier(), cacheBy: indexPath, configuration: { (cell) in
                (cell as! CellBindViewModelProtocol).bind(with: cellViewModel)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = self.goodPriceVM.dataSource[indexPath.row]
        DispatchQueue.main.async {
            cellViewModel.cellSelected()
        }
    }
}
