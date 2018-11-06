//
//  HomeViewControllerViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/21.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
import PKHUD

class HomeViewControllerViewModel:BaseCategoryViewModelProtocol {
    
    public var categoriesDataSource: [CellViewModelProtocol] = []
    
    public var categoriesListDataSource: [CellViewModelProtocol] = []
    
    private var bag = DisposeBag()
    
    func requestNewData(complete:@escaping ((Error?)->Void)) {
        HUD.show(.progress)
        requestCategories().subscribe(onNext: { [weak self] (categories) in
            let recommendCategory = Category(id:0,name:"推荐")
            var categoryArr = [recommendCategory]
            categoryArr.append(contentsOf: categories)
            self?.categoriesDataSource = categoryArr.map {
                return CategoryCollectionViewCellViewModel(category: $0)
            }
            self?.categoriesListDataSource = categoryArr.map {
                return HomeCollectionViewListCellViewModel(category: $0)
            }
        }, onError: { (error) in
            DispatchQueue.main.async {
                HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription),delay: 1.0)
                complete(error)
            }
        }, onCompleted: {
            DispatchQueue.main.async {
                HUD.hide(animated: true)
                complete(nil)
            }
        }).disposed(by: bag)
    }
    
    func requestCategories() -> Observable<[Category]> {
        return msdApiProvider.rx.request(.categoriesListApi).map([Category].self, atKeyPath: nil, using: JSONDecoder(), failsOnEmptyData: false).asObservable()
    }
}
