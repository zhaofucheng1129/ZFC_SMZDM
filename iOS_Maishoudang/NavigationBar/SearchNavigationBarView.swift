//
//  SearchNavigationBarView.swift
//  
//
//  Created by 赵福成 on 2018/7/20.
//

import UIKit
import SwifterSwift
import RxSwift
import RxCocoa

class SearchNavigationBarView: UIView {
    
    private var bag = DisposeBag()
    
    @IBOutlet weak var categoryBtn: UIButton!
    
    @IBOutlet weak var moreBtn: UIButton!
    
    @IBOutlet weak var searchContainer: UIView!
    
    @IBOutlet weak var searchBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        searchBtn.rx.tap.bind {
            NavigationMediator.TopNavigationViewController()?.pushViewController(NavigationMediator.SearchPage(), animated: true)
        }.disposed(by: bag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchContainer.roundCorners(.allCorners, radius: searchContainer.height / 2)
    }

}
