//
//  ViewController.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/6/30.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import Moya

class GoodPriceViewController: MSDBaseViewController {
    
    let goodPriceVM = GoodPriceViewControllerViewModel()
    
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
        
        tableView.register(UINib(nibName: CellReuseIdentifierManager.GoodPriceCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.GoodPriceCellId)
        tableView.register(UINib(nibName: CellReuseIdentifierManager.BannerCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.BannerCellId)
        tableView.register(UINib(nibName: CellReuseIdentifierManager.HomeCategoriesCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.HomeCategoriesCellId)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.mj_header = MSDRefreshHeader(refreshingBlock: { [weak self] in
            if tableView.mj_footer.state == MJRefreshState.refreshing {
                tableView.mj_header.endRefreshing()
                return
            }
            self?.goodPriceVM.requestNewData(complete: { (error) in
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
            self?.goodPriceVM.requestNextPageData { (error) in
                tableView.mj_footer.endRefreshing()
                if error == nil {
                    tableView.reloadData()
                }
            }
        })
    }
}

extension GoodPriceViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.goodPriceVM.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellViewModel = self.goodPriceVM.dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellReuseIdentifier(), for: indexPath)
        return cell
    }
}

extension GoodPriceViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellViewModel = self.goodPriceVM.dataSource[indexPath.row]
        (cell as! CellBindViewModelProtocol).bind(with: cellViewModel)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = self.goodPriceVM.dataSource[indexPath.row]
        return tableView.fd_heightForCell(withIdentifier: cellViewModel.cellReuseIdentifier(), cacheBy: indexPath, configuration: { (cell) in
            (cell as! CellBindViewModelProtocol).bind(with: cellViewModel)
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = self.goodPriceVM.dataSource[indexPath.row]
        DispatchQueue.main.async {
            cellViewModel.cellSelected()
        }
    }
}
