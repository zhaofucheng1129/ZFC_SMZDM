//
//  MainViewControllerViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/24.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation
import RxSwift

class MainViewControllerViewModel {
    
    private var bag = DisposeBag()
    
    private let updateSubject = PublishSubject<Void>()
    
    var updateObservable: Observable<Void> {
        return updateSubject.asObservable()
    }
    
    public var dataSource: [CellViewModelProtocol] = []
    
    init() {
        let items = [["icon":"ico_user_icon_message","item":"我的消息"],
                     ["icon":"ico_user_icon_collect","item":"我的收藏"],
                     ["icon":"ico_user_icon_publish","item":"我的发布"],
                     ["icon":"ico_user_icon_code","item":"兑换记录"],
                     ["icon":"ico_user_icon_robot","item":"买手党客服"]]
        
        var datas:[CellViewModelProtocol] = items.map { MainItemTableViewCellViewModel(info: $0) }
        datas.insert(MainCategoriesTableViewCellViewModel(), at: 0)
        datas.insert(MainHeaderTableViewCellViewModel(), at: 0)
        
        if let _ = CacheManager.getUserInfo() {
            datas.append(LogoutTableViewCellViewModel())
        }
        
        dataSource = datas
        updateSubject.onNext(())
        
        
        CacheManager.shared.currentUser.subscribe(onNext: { [weak self] (user) in
            if let strongSelf = self {
                var datas:[CellViewModelProtocol] = items.map { MainItemTableViewCellViewModel(info: $0) }
                datas.insert(MainCategoriesTableViewCellViewModel(), at: 0)
                datas.insert(MainHeaderTableViewCellViewModel(), at: 0)
                
                if let _ = user {
                    datas.append(LogoutTableViewCellViewModel())
                }
                
                strongSelf.dataSource = datas
                strongSelf.updateSubject.onNext(())
            }
        }).disposed(by: bag)
    }
}


