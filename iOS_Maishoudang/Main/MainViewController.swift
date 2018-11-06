//
//  MainViewController.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/20.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class MainViewController: MSDBaseViewController {

    let mainVM: MainViewControllerViewModel = MainViewControllerViewModel()
    
    private var bag = DisposeBag()
    
    private let mainHeight: CGFloat = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isHidden = true
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom).offset(-(self.tabBarVC?.tabBarHeight ?? 0))
        }
        
        tableView.estimatedRowHeight = 0
        
        tableView.register(UINib(nibName: CellReuseIdentifierManager.MainHeaderCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.MainHeaderCellId)
        tableView.register(UINib(nibName: CellReuseIdentifierManager.MainCategoriesCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.MainCategoriesCellId)
        tableView.register(UINib(nibName: CellReuseIdentifierManager.MainItemCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.MainItemCellId)
        tableView.register(UINib(nibName: CellReuseIdentifierManager.LogoutCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.LogoutCellId)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.mainVM.updateObservable.subscribe(onNext: { () in
            tableView.reloadData()
        }).disposed(by: bag)
        
//        if let headerView = Bundle.main.loadNibNamed("MainHeaderView", owner: nil, options: nil)?.last as? MainHeaderView {
//            let headerContainerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: mainHeight))
//
//            headerContainerView.addSubview(headerView)
//            headerView.snp.makeConstraints { (make) in
//                make.edges.equalToSuperview()
//            }
//
//            tableView.tableHeaderView = headerContainerView
//        }
    }

}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainVM.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = self.mainVM.dataSource[indexPath.row]

        return tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellReuseIdentifier(), for: indexPath)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellViewModel = self.mainVM.dataSource[indexPath.row]
        (cell as! CellBindViewModelProtocol).bind(with: cellViewModel)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = self.mainVM.dataSource[indexPath.row]
        
        return tableView.fd_heightForCell(withIdentifier: cellViewModel.cellReuseIdentifier(), cacheBy: indexPath, configuration: { (cell) in
            
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = self.mainVM.dataSource[indexPath.row]
        cellViewModel.cellSelected()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
