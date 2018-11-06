//
//  GoodsCollectionViewListCellViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/31.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import PKHUD

class GoodsCollectionViewListCellViewModel: RecommendListCollectionViewCellViewModel {
    
    let category: Category
    
    init(category: Category) {
        self.category = category
    }
    
    public var dataSource: [CellViewModelProtocol] = []
    
    private var pageIndex = 1
    
    private var bag = DisposeBag()
    
    
    func cellReuseIdentifier() -> String {
        return CellReuseIdentifierManager.RecommendListCollectionCellId
    }
    
    func requestNewData(complete: @escaping ((Error?) -> Void)) {
        if category.id == 0 {
            requestGoodsPageList(complete: complete)
        } else {
            requestCategoryPageList(complete: complete)
        }
    }
    
    func requestNextPageData(complete: @escaping ((Error?) -> Void)) {
        if category.id == 0 {
            requestNextGoodsPageList(complete: complete)
        } else {
            requestCategoriesNextPageList(complete: complete)
        }
    }
    
    private func requestCategoryPageList(complete:@escaping ((Error?)->Void)) {
        pageIndex = 1
        requestCategoryList(pageIndex: pageIndex).subscribe(onNext: { [weak self] (products) in
            let goodPriceCells = products.map { (product) -> CellViewModelProtocol in
                if product.type == .experience || product.type == .experiences {
                    return GoodsTableViewCellViewModel(product:product)
                } else if product.type == .discovery || product.type == .discoveries {
                    return ArticleTableViewCellViewModel(product:product)
                } else {
                    return GoodPriceTableViewCellViewModel(product:product)
                }
            }
            
            if let strongSelf = self {
                strongSelf.dataSource = []
                strongSelf.dataSource.append(contentsOf: goodPriceCells)
            }
            }, onError: { (error) in
                DispatchQueue.main.async {
                    HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription),delay: 1.0)
                    complete(error)
                }
        }, onCompleted: {
            DispatchQueue.main.async {
                complete(nil)
            }
        }).disposed(by: bag)
    }
    
    private func requestCategoriesNextPageList(complete:@escaping((Error?)->Void)) {
        requestCategoryList(pageIndex: pageIndex + 1).subscribe(onNext: { [weak self](products) in
            if let strongSelf = self {
                let goodPriceCells = products.map { (product) -> CellViewModelProtocol in
                    if product.type == .experience || product.type == .experiences {
                        return GoodsTableViewCellViewModel(product:product)
                    } else if product.type == .discovery || product.type == .discoveries {
                        return ArticleTableViewCellViewModel(product:product)
                    } else {
                        return GoodPriceTableViewCellViewModel(product:product)
                    }
                }
                strongSelf.pageIndex += 1
                strongSelf.dataSource.append(contentsOf: goodPriceCells)
            }
            }, onError: { (error) in
                DispatchQueue.main.async {
                    HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription),delay: 1.0)
                    complete(error)
                }
        }, onCompleted: {
            DispatchQueue.main.async {
                complete(nil)
            }
        }).disposed(by: bag)
    }
    
    private func requestGoodsPageList(complete:@escaping ((Error?)->Void)) {
        pageIndex = 1
        requestExperiencesList(pageIndex: pageIndex).filter { (products) -> Bool in
            return products.count > 0
            }.subscribe(onNext: { [weak self] (products) in
                if let strongSelf = self {
                    let bannerVM = BannerTableViewCellViewModel(galleries: [])
                    let categoryVM = HomeCategoriesTableViewCellViewModel()
                    let goodsCells = products.map { GoodsTableViewCellViewModel(product:$0) }
                    //.filter { $0.type == "experiences" }
                    strongSelf.dataSource = []
                    strongSelf.dataSource.append(bannerVM)
                    strongSelf.dataSource.append(categoryVM)
                    strongSelf.dataSource.append(contentsOf: goodsCells)
                }
            }, onError: { (error) in
//                print(error)
                DispatchQueue.main.async {
                    HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription),delay: 1.0)
                    complete(error)
                }
            }, onCompleted: {
                DispatchQueue.main.async {
                    complete(nil)
                }
            }, onDisposed: {
//                print("释放")
            }).disposed(by: bag)
    }

    private func requestNextGoodsPageList(complete:@escaping ((Error?)->Void)) {
        requestExperiencesList(pageIndex: pageIndex + 1).filter { (products) -> Bool in
            return products.count > 0
            }.subscribe(onNext: { [weak self] (products) in
                if let strongSelf = self {
                    let goodsCells = products.map { GoodsTableViewCellViewModel(product:$0) }
                    //.filter { $0.type == "experiences" }
                    strongSelf.dataSource.append(contentsOf: goodsCells)
                    strongSelf.pageIndex += 1
                }
            }, onError: { (error) in
                    DispatchQueue.main.async {
                        HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription),delay: 1.0)
                        complete(error)
                    }
            }, onCompleted: {
                DispatchQueue.main.async {
                    complete(nil)
                }
            }).disposed(by: bag)
    }

    private func requestExperiencesList(pageIndex: Int) -> Observable<[Product]> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return msdApiProvider.rx.request(.experiencesApi(page: pageIndex)).map([Product].self, atKeyPath: nil, using: decoder, failsOnEmptyData: false).asObservable()
    }
    
    private func requestCategoryList(pageIndex: Int) -> Observable<[Product]> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return msdApiProvider.rx.request(.searchApi(type: .experience, keyWord: category.name, page: pageIndex)).map([Product].self, atKeyPath: nil, using: decoder, failsOnEmptyData: false).asObservable()
    }
}
