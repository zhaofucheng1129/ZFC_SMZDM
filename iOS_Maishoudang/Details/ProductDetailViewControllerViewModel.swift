//
//  GoodPriceDetailViewControllerViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/24.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import PKHUD

class ProductDetailViewControllerViewModel: NSObject {
    private let commentableType: recommendType
    
    private let productId: UInt
    
    var productDetail: ProductDetail?
    
    var dataSource: [CellViewModelProtocol] = []
    
    var cellSelectedCommand: Observable<Void> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            
            self?.goToCommentListPage()
            
            observer.onCompleted()
            return Disposables.create { }
        })
    }
    
    private var bag = DisposeBag()
    
    init(commentableType: recommendType, productId:UInt) {
        self.productId = productId
        self.commentableType = commentableType
        
        super.init()
    }
    
    func goToCommentListPage() {
        if let detail = self.productDetail {
            NavigationMediator.TopNavigationViewController()?.pushViewController(NavigationMediator.CommentListPage(commentableType: detail.type, commentableId: detail.id),animated: true)
        }
    }
    
    func requestNewData(complete:@escaping (()->Void)) {
        HUD.show(.progress)
        self.requestDetailData().subscribe(onNext: { [weak self] (productDetail) in
            if let strongSelf = self {
            
                strongSelf.productDetail = productDetail
                
                if let comments = productDetail.comments {
                    strongSelf.dataSource = comments.map {
                        if let _ = $0.parent {
                            return ReplyCommentTableViewCellViewModel(comment: $0, cellSelecteCommand: strongSelf.cellSelectedCommand)
                        } else {
                            return NormalCommentTableViewCellViewModel(comment: $0, cellSelecteCommand: strongSelf.cellSelectedCommand)
                        }
                    }
                }
                
                if let _ = strongSelf.dataSource.first {
                    //头Cell
                    let commentHeader = CommentHeaderTableViewCellViewModel()
                    strongSelf.dataSource.insert(commentHeader, at: 0)
                }
                
                DispatchQueue.main.async {
                    complete()
                }
            }
        }, onError: { (error) in
            HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription),delay: 1.0)
        }, onCompleted: {
            HUD.hide(animated: true)
        }, onDisposed: {
            
        }).disposed(by: bag)
    }
    
    private func requestDetailData() -> Observable<ProductDetail> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return msdApiProvider.rx.request(.detailApi(type: self.commentableType, recommendId: productId)).map(ProductDetail.self, atKeyPath: nil, using: decoder, failsOnEmptyData: false).asObservable()
    }
    
    public func requestSetFavorite(complete:@escaping(()->Void)) {
        if let productDetail = productDetail {
            HUD.show(.progress)
            msdApiProvider.rx.request(.favoriteApi(favorableType: productDetail.type, favorableId: productDetail.id)).mapJSON().subscribe(onSuccess: { (json) in
                if let dict = json as? [String : AnyObject] {
                    if let _ = dict["id"] {
                        HUD.flash(.success, delay: 1)
                        complete()
                    } else if let _ = dict["error"]{
                        HUD.flash(.label("已经收藏成功"), delay: 1)
                    } else {
                        HUD.flash(.labeledError(title: "错误", subtitle: "操作失败"),delay: 1.0)
                    }
                } else {
                    HUD.flash(.labeledError(title: "错误", subtitle: "操作失败"),delay: 1.0)
                }
            }) { (error) in
                HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription),delay: 1.0)
            }.disposed(by: bag)
        }
    }
    
    public func requestAgree(complete:@escaping(()->Void)) {
        if let productDetail = productDetail {
            HUD.show(.progress)
            msdApiProvider.rx.request(.agreeApi(gradableType: productDetail.type, gradableId: productDetail.id, agreeType: "up")).mapJSON().subscribe(onSuccess: { (json) in
                if let dict = json as? [String : AnyObject] {
                    if let _ = dict["id"] {
                        HUD.flash(.success, delay: 1)
                        complete()
                    } else if let _ = dict["error"]{
                        HUD.flash(.label("已经点赞成功"), delay: 1)
                    } else {
                        HUD.flash(.labeledError(title: "错误", subtitle: "操作失败"),delay: 1.0)
                    }
                } else {
                    HUD.flash(.labeledError(title: "错误", subtitle: "操作失败"),delay: 1.0)
                }
            }) { (error) in
                HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription),delay: 1.0)
                }.disposed(by: bag)
        }
    }
}
