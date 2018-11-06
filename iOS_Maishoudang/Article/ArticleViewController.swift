//
//  ArticleViewController.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/20.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

class ArticleViewController: MSDBaseViewController {
    
    private let articleVM = ArticleViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.bottom.equalTo(self.view.snp.bottom).offset(-(self.tabBarVC?.tabBarHeight ?? 0))
        }
        
        tableView.estimatedRowHeight = 0
        
        tableView.register(UINib(nibName: CellReuseIdentifierManager.ArticleCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.ArticleCellId)
        tableView.register(UINib(nibName: CellReuseIdentifierManager.BannerCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.BannerCellId)
        tableView.register(UINib(nibName: CellReuseIdentifierManager.HomeCategoriesCellId, bundle: Bundle.main), forCellReuseIdentifier: CellReuseIdentifierManager.HomeCategoriesCellId)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.mj_header = MSDRefreshHeader(refreshingBlock: { [weak self] in
            if tableView.mj_footer.state == MJRefreshState.refreshing {
                tableView.mj_header.endRefreshing()
                return
            }
            self?.articleVM.requestNewData(complete: { (error) in
                tableView.mj_header.endRefreshing()
                if error == nil {
                    tableView.reloadData()
                }
            })
        })
        
        tableView.mj_header.beginRefreshing()
        
        tableView.mj_footer = MSDRefreshFooter(refreshingBlock: { [weak self] in
            if tableView.mj_header.state == MJRefreshState.refreshing {
                tableView.mj_header.endRefreshing()
            }
            self?.articleVM.requestNextPageData { (error) in
                tableView.mj_footer.endRefreshing()
                if error == nil {
                    tableView.reloadData()
                }
            }
        })
    }
}

extension ArticleViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleVM.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = self.articleVM.dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellReuseIdentifier(), for: indexPath)
        return cell
    }
}

extension ArticleViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellViewModel = self.articleVM.dataSource[indexPath.row]
        (cell as! CellBindViewModelProtocol).bind(with: cellViewModel)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = self.articleVM.dataSource[indexPath.row]
        return tableView.fd_heightForCell(withIdentifier: cellViewModel.cellReuseIdentifier(), cacheBy: indexPath, configuration: { (cell) in
            (cell as! CellBindViewModelProtocol).bind(with: cellViewModel)
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = self.articleVM.dataSource[indexPath.row]
        // iOS bug: https://github.com/lkzhao/Hero/issues/106 https://github.com/lkzhao/Hero/issues/79
        DispatchQueue.main.async {
            cellViewModel.cellSelected()
        }
    }
}
