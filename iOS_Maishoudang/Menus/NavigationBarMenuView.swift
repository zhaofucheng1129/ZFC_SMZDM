//
//  NavigationBarMenuView.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/8/8.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

class NavigationBarMenuView: UIView {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var background: UIView!
    
    var items:[[String:String]] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(UINib(nibName: CellReuseIdentifierManager.MenuItemCellId, bundle: Bundle.main), forCellReuseIdentifier: CellReuseIdentifierManager.MenuItemCellId)
        
        items = [
            ["itemName":"发爆料", "iconName":"icon-Original"],
            ["itemName":"发晒单", "iconName":"icon-Original"],
            ["itemName":"发帖子", "iconName":"icon-Original"],
            ["itemName":"扫一扫", "iconName":"icon-Original"]
        ]
        
        background.cornerRadius = 5
    }

}

extension NavigationBarMenuView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifierManager.MenuItemCellId, for: indexPath)
        return cell
    }
}

extension NavigationBarMenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellViewModel = self.items[indexPath.row]
        (cell as! MenuItemViewCell).bind(with: cellViewModel)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NavMenuSelectItem"), object: nil)
        
        NavigationMediator.TopNavigationViewController()?.pushViewController(NavigationMediator.PublishPage(), animated: true)
    }
}
