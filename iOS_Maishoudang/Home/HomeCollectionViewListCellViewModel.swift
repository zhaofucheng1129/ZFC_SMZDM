//
//  RecommendListCollectionViewCellViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/30.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import PKHUD

class HomeCollectionViewListCellViewModel: RecommendListCollectionViewCellViewModel {

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
    
    func requestNewData(complete:@escaping ((Error?)->Void)) {
        if category.id == 0 {
            requestRecommendPageList(complete: complete)
        } else {
            requestCategoryPageList(complete: complete)
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
    
    private func requestRecommendPageList(complete:@escaping ((Error?)->Void)) {
        pageIndex = 1
        Observable.combineLatest(requestBannerList(),requestRecommendList(pageIndex: pageIndex)) {
            return ($0, $1)
            }.subscribe(onNext: { [weak self] in
                let (galleries, products) = $0
                if let strongSelf = self {
                    let bannerVM = BannerTableViewCellViewModel(galleries: galleries)
                    let categoryVM = HomeCategoriesTableViewCellViewModel()
                    let goodPriceCells = products.map { (product) -> CellViewModelProtocol in
                        if product.type == .experience || product.type == .experiences {
                            return GoodsTableViewCellViewModel(product:product)
                        } else if product.type == .discovery || product.type == .discoveries {
                            return ArticleTableViewCellViewModel(product:product)
                        } else {
                            return GoodPriceTableViewCellViewModel(product:product)
                        }
                    }
                    
                    strongSelf.dataSource = []
                    strongSelf.dataSource.append(bannerVM)
                    strongSelf.dataSource.append(categoryVM)
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
            }, onDisposed: {
                
            }).disposed(by: bag)
    }
    
    func requestNextPageData(complete:@escaping ((Error?)->Void)) {
        if category.id == 0 {
            requestRecommendNextPageList(complete: complete)
        } else {
            requestCategoriesNextPageList(complete: complete)
        }
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
    
    private func requestRecommendNextPageList(complete:@escaping ((Error?)->Void)) {
        requestRecommendList(pageIndex: pageIndex + 1).subscribe(onNext: { [weak self] (products) in
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
    
    private func requestBannerList() -> Observable<[Gallery]> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return msdApiProvider.rx.request(.galleriesApi).map([Gallery].self, atKeyPath: nil, using: decoder, failsOnEmptyData: false).asObservable()
    }
    
    private func requestRecommendList(pageIndex: Int) -> Observable<[Product]> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return msdApiProvider.rx.request(.dealsApi(page: pageIndex)).map([Product].self, atKeyPath: nil, using: decoder, failsOnEmptyData: false).asObservable()
    }
    
    private func requestCategoryList(pageIndex: Int) -> Observable<[Product]> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return msdApiProvider.rx.request(.searchApi(type: .deal, keyWord: category.name, page: pageIndex)).map([Product].self, atKeyPath: nil, using: decoder, failsOnEmptyData: false).asObservable()
    }
}
