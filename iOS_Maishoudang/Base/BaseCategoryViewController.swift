//
//  BaseCategoryViewController.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/31.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

import UIKit
import SnapKit
import UITableView_FDTemplateLayoutCell
import RxSwift
import RxCocoa
import SwifterSwift

class BaseCategoryViewController: MSDBaseViewController {

    internal var baseVM: BaseCategoryViewModelProtocol!
    
    private var channelCollectionView: UICollectionView!
    
    private var recommendCollectionView: UICollectionView!
    
    private var indicatorView: UIView!
    
    //还原选择项
    private var currentSelectIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    /// 代码控制滚动标识位
    /// 真 代码控制滚动 scrollViewDidScroll中的代码不执行
    /// 否 不是代码控制滚动
    private var isCodeScroll: Bool = false
    
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let channelContainerView = UIView()
        view.addSubview(channelContainerView)
        channelContainerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.height.equalTo(30)
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        channelCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        channelCollectionView.backgroundColor = UIColor.white
        channelCollectionView.showsHorizontalScrollIndicator = false
        channelCollectionView.contentInset = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 15.0)
        channelContainerView.addSubview(channelCollectionView)
        channelCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        channelCollectionView.register(UINib(nibName: CellReuseIdentifierManager.CategoryCollectionCellId, bundle: Bundle.main),
                                       forCellWithReuseIdentifier: CellReuseIdentifierManager.CategoryCollectionCellId)
        
        channelCollectionView.dataSource = self
        channelCollectionView.delegate = self
        
        
        let recommendListContainer = UIView()
        view.addSubview(recommendListContainer)
        recommendListContainer.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(channelContainerView.snp.bottom)
            make.bottom.equalTo(self.view.snp.bottom).offset(-(self.tabBarVC?.tabBarHeight ?? 0))
        }
        
        
        let recommendFlowLayout = UICollectionViewFlowLayout()
        recommendFlowLayout.scrollDirection = .horizontal
        recommendFlowLayout.minimumInteritemSpacing = 0
        recommendFlowLayout.minimumLineSpacing = 0
        
        recommendCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: recommendFlowLayout)
        recommendCollectionView.backgroundColor = UIColor.white
        recommendCollectionView.showsHorizontalScrollIndicator = false
        recommendCollectionView.isPagingEnabled = true
        recommendListContainer.addSubview(recommendCollectionView)
        recommendCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        recommendCollectionView.register(UINib(nibName: CellReuseIdentifierManager.RecommendListCollectionCellId, bundle: Bundle.main),forCellWithReuseIdentifier: CellReuseIdentifierManager.RecommendListCollectionCellId)
        
        recommendCollectionView.dataSource = self
        recommendCollectionView.delegate = self
        
        indicatorView = UIView()
        indicatorView.backgroundColor = UIColor(hexString: "FF6E6E")
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        channelCollectionView.superview?.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.height.equalTo(3)
            make.width.equalTo(0)
        }
        indicatorView.cornerRadius = 1.5
        
        self.baseVM.requestNewData { [weak self] (error) in
            if nil == error, let strongSelf = self {
                strongSelf.channelCollectionView.reloadData()
                strongSelf.recommendCollectionView.reloadData()
                strongSelf.channelCollectionView.performBatchUpdates(nil, completion: { (finished) in
                    strongSelf.indicatorViewAnimation(to: strongSelf.currentSelectIndex)
                })
            }
        }
    }
    
    func indicatorViewAnimation(to indexPath: IndexPath) {
        if self.baseVM.categoriesDataSource.count <= 0 {
            return
        }
        
        guard let cellLayoutAttribute = channelCollectionView.layoutAttributesForItem(at: indexPath) else {
            return
        }
        let rectInCollectionView = channelCollectionView.convert(cellLayoutAttribute.frame, to: channelCollectionView.superview)
        
        
        
        if let superView = indicatorView.superview {
            indicatorView.snp.updateConstraints { (make) in
                make.left.equalTo(superView.snp.left).offset(rectInCollectionView.origin.x)
                make.width.equalTo(rectInCollectionView.size.width)
            }
        }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.indicatorView.superview?.layoutIfNeeded()
        }
    }
    
}

extension BaseCategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == channelCollectionView {
            return self.baseVM.categoriesDataSource.count
        } else if collectionView == recommendCollectionView {
            return self.baseVM.categoriesListDataSource.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellViewModel: CellViewModelProtocol
        if collectionView == channelCollectionView {
            cellViewModel = self.baseVM.categoriesDataSource[indexPath.row]
        } else {
            cellViewModel = self.baseVM.categoriesListDataSource[indexPath.row]
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellViewModel.cellReuseIdentifier(), for: indexPath)
        (cell as! CellBindViewModelProtocol).bind(with: cellViewModel)
        return cell
    }
}

extension BaseCategoryViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == recommendCollectionView {
            self.realDidEndScroll(collectionView: recommendCollectionView)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == channelCollectionView {
            if currentSelectIndex.row < self.baseVM.categoriesDataSource.count {
                guard let cellLayoutAttribute = channelCollectionView.layoutAttributesForItem(at: currentSelectIndex) else {
                    return
                }
                //获取当前cell在collection中的位置
                let rectInCollectionView = self.channelCollectionView.convert(cellLayoutAttribute.frame, to: self.channelCollectionView.superview)
                
                if let superView = indicatorView.superview {
                    indicatorView.snp.updateConstraints { (make) in
                        make.left.equalTo(superView.snp.left).offset(rectInCollectionView.origin.x)
                        make.width.equalTo(rectInCollectionView.size.width)
                    }
                    
                    superView.layoutIfNeeded()
                }
            }
        } else if scrollView == recommendCollectionView {
            if !self.isCodeScroll {
                let offsetX = scrollView.contentOffset.x
                let scrollWidht = scrollView.width
                
                if offsetX >= 0 && offsetX <= (scrollWidht * CGFloat(self.baseVM.categoriesListDataSource.count)) {
                    let rowIndex = floor((offsetX - scrollWidht / 2) / scrollWidht) + 1
                    let indexPath = IndexPath(row: Int(rowIndex), section: 0)
                    self.indicatorViewAnimation(to: indexPath)
                }
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == recommendCollectionView {
            self.realDidEndScroll(collectionView: recommendCollectionView)
            
            self.isCodeScroll = false
        }
    }
    
    func realDidEndScroll(collectionView: UICollectionView) {
        if collectionView == recommendCollectionView {
            let rowIndex = Int(recommendCollectionView.contentOffset.x / recommendCollectionView.width)
            let indexPath = IndexPath(row: rowIndex, section: 0)
            
//            if rowIndex < self.baseVM.categoriesListDataSource.count {
//                let viewModel = self.baseVM.categoriesListDataSource[rowIndex]
//                let cell = self.recommendCollectionView.cellForItem(at: indexPath)
//                (cell as! CellBindViewModelProtocol).bind(with: viewModel)
//            }
            
            if indexPath.row < self.baseVM.categoriesListDataSource.count {
                self.indicatorViewAnimation(to: indexPath)
            }
            
            self.currentSelectIndex = indexPath
            
            if rowIndex < self.baseVM.categoriesDataSource.count {
                self.channelCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
}

extension BaseCategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == channelCollectionView {
            currentSelectIndex = indexPath
            
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            self.indicatorViewAnimation(to: indexPath)
            
            //点击分类使下面的列表滚动到指定位置
            if indexPath.row < self.baseVM.categoriesListDataSource.count {
                self.recommendCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                
                //设置状态为代码控制滚动
                self.isCodeScroll = true
            }
        }
    }
}

extension BaseCategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == channelCollectionView {
            let cellViewModel = self.baseVM.categoriesDataSource[indexPath.row]
            let size = (cellViewModel as! CategoryCollectionViewCellViewModel).cellSize()
            return size
        } else {
            return recommendCollectionView.frame.size
        }
    }
}
