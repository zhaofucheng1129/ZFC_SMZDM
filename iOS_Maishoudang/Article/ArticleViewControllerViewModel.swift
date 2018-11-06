//
//  ArticleViewControllerViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/22.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PKHUD

class ArticleViewControllerViewModel {
    public var dataSource: [CellViewModelProtocol] = []
    
    private var pageIndex = 1
    
    private var bag = DisposeBag()
    
    func requestNewData(complete:@escaping ((Error?)->Void)) {
        requestDiscoveriesList(pageIndex: pageIndex + 1).filter { (products) -> Bool in
            return products.count > 0
            }.subscribe(onNext: { [weak self] (products) in
                if let strongSelf = self {
                    let bannerVM = BannerTableViewCellViewModel(galleries: [])
                    let categoryVM = HomeCategoriesTableViewCellViewModel()
                    let articleCells = products.map { ArticleTableViewCellViewModel(product:$0) }
                    //.filter { $0.type == "discoveries" }
                    strongSelf.dataSource = []
                    strongSelf.dataSource.append(bannerVM)
                    strongSelf.dataSource.append(categoryVM)
                    strongSelf.dataSource.append(contentsOf: articleCells)
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
            }, onDisposed: {
                print("释放")
            }).disposed(by: bag)
    }
    
    func requestNextPageData(complete:@escaping ((Error?)->Void)) {
        pageIndex += 1
        requestDiscoveriesList(pageIndex: pageIndex).filter { (products) -> Bool in
            return products.count > 0
            }.subscribe(onNext: { [weak self] (products) in
                if let strongSelf = self {
                    let articleCells = products.map { ArticleTableViewCellViewModel(product:$0) }
                    strongSelf.dataSource.append(contentsOf: articleCells)
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
    
    func requestDiscoveriesList(pageIndex: Int) -> Observable<[Product]> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return msdApiProvider.rx.request(.discoveriesApi(page: pageIndex)).map([Product].self, atKeyPath: nil, using: decoder, failsOnEmptyData: false).asObservable()
    }
}
