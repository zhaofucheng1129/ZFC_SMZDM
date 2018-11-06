//
//  RecommendListCollectionViewCell.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/30.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

class RecommendListCollectionViewCell: UICollectionViewCell, CellBindViewModelProtocol {
    
    var recommendListVM: RecommendListCollectionViewCellViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none

        tableView.estimatedRowHeight = 0

        tableView.register(UINib(nibName: CellReuseIdentifierManager.GoodPriceCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.GoodPriceCellId)
        tableView.register(UINib(nibName: CellReuseIdentifierManager.GoodsCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.GoodsCellId)
        tableView.register(UINib(nibName: CellReuseIdentifierManager.ArticleCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.ArticleCellId)
        tableView.register(UINib(nibName: CellReuseIdentifierManager.BannerCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.BannerCellId)
        tableView.register(UINib(nibName: CellReuseIdentifierManager.HomeCategoriesCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.HomeCategoriesCellId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        replaceRefresh()
    }

    func replaceRefresh() {
        
        if let mjHeader = tableView.mj_header,mjHeader.scrollViewOriginalInset.top > 0 && mjHeader.state == MJRefreshState.idle {
            let oldContentInset = self.tableView.contentInset
            self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: oldContentInset.left, bottom: oldContentInset.bottom, right: oldContentInset.right)
        }
        
        tableView.mj_header = MSDRefreshHeader(refreshingBlock: { [weak self] in
            if self?.tableView.mj_footer.state == MJRefreshState.refreshing {
                self?.tableView.mj_footer.endRefreshing()
            }
            self?.recommendListVM?.requestNewData(complete: { error in
                self?.tableView.mj_header.endRefreshing()
                if error == nil {
                    self?.tableView.reloadData()
                }
            })
        })
        
        tableView.mj_footer = MSDRefreshFooter(refreshingBlock: { [weak self] in
            if self?.tableView.mj_header.state == MJRefreshState.refreshing {
                self?.tableView.mj_header.endRefreshing()
            }
            self?.recommendListVM?.requestNextPageData { (error) in
                self?.tableView.mj_footer.endRefreshing()
                if error == nil {
                    self?.tableView.reloadData()
                }
            }
        })
        
        if let count = self.recommendListVM?.dataSource.count, count <= 0 {
            tableView.mj_header.beginRefreshing()
        } else {
            tableView.reloadData()
        }
    }
    
    func bind(with vm: CellViewModelProtocol) {
        if let vm = vm as? RecommendListCollectionViewCellViewModel {
            self.recommendListVM = vm
            replaceRefresh()
        }
    }
}

extension RecommendListCollectionViewCell : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let vm = self.recommendListVM else {
            return 0
        }
        return vm.dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let vm = self.recommendListVM, vm.dataSource.count > indexPath.row else {
            return tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        }
        let cellViewModel = vm.dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellReuseIdentifier(), for: indexPath)
        return cell
    }
}

extension RecommendListCollectionViewCell : UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let vm = self.recommendListVM, vm.dataSource.count > indexPath.row else {
            return
        }
        let cellViewModel = vm.dataSource[indexPath.row]
        (cell as! CellBindViewModelProtocol).bind(with: cellViewModel)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let vm = self.recommendListVM, vm.dataSource.count > indexPath.row else {
            return 0
        }
        let cellViewModel = vm.dataSource[indexPath.row]
        return tableView.fd_heightForCell(withIdentifier: cellViewModel.cellReuseIdentifier(), cacheBy: indexPath, configuration: { (cell) in
            (cell as! CellBindViewModelProtocol).bind(with: cellViewModel)
        })
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vm = self.recommendListVM, vm.dataSource.count > indexPath.row else {
            return
        }
        let cellViewModel = vm.dataSource[indexPath.row]
        // iOS bug: https://github.com/lkzhao/Hero/issues/106 https://github.com/lkzhao/Hero/issues/79
        DispatchQueue.main.async {
            cellViewModel.cellSelected()
        }
//
    }
}
