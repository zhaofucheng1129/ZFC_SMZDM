//
//  CommentListViewController.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/29.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import IQKeyboardManagerSwift

class CommentListViewController: MSDBaseViewController {

    private let commentVM : CommentListViewControllerViewModel
    
    private var tableView: UITableView!
    
    private var commentOperationView: CommentOperationView!
    
    private var bag = DisposeBag()
    
    init(vm: CommentListViewControllerViewModel) {
        self.commentVM = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        titleLabel.text = "相关评论"
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.navigationBar.snp.bottom)
//            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        let bottomView = Bundle.main.loadNibNamed("CommentOperationView", owner: nil, options: nil)?.last as? CommentOperationView
        
        if let bottomView = bottomView {
            commentOperationView = bottomView
            
            view.addSubview(bottomView)
            bottomView.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(tableView.snp.bottom)
            }
        } else {
            tableView.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.view.snp.bottom)
            }
        }
        
        tableView.estimatedRowHeight = 0
        
        tableView.register(UINib(nibName: CellReuseIdentifierManager.CommentHeaderCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.CommentHeaderCellId)
        tableView.register(UINib(nibName: CellReuseIdentifierManager.ReplyCommentCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.ReplyCommentCellId)
        tableView.register(UINib(nibName: CellReuseIdentifierManager.NormalCommentCellId, bundle: Bundle.main),
                           forCellReuseIdentifier: CellReuseIdentifierManager.NormalCommentCellId)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.mj_header = MSDRefreshHeader(refreshingBlock: { [weak self] in
            if let strongSelf = self {
                if strongSelf.tableView.mj_footer.state == MJRefreshState.refreshing {
                    strongSelf.tableView.mj_footer.endRefreshing()
                }
                strongSelf.commentVM.requestNewData(complete: { error in
                    strongSelf.tableView.mj_header.endRefreshing()
                    if error == nil {
                        strongSelf.tableView.reloadData()
                    }
                })
            }
        })

        tableView.mj_header.beginRefreshing()
//
        tableView.mj_footer = MSDRefreshFooter(refreshingBlock: { [weak self] in
            if let strongSelf = self {
                if strongSelf.tableView.mj_header.state == MJRefreshState.refreshing {
                    strongSelf.tableView.mj_header.endRefreshing()
                }
                strongSelf.commentVM.requestNextPageData { (error) in
                    strongSelf.tableView.mj_footer.endRefreshing()
                    if error == nil {
                        strongSelf.tableView.reloadData()
                    }
                }
            }
        })
        
//        let tapGesture = UITapGestureRecognizer()
//        view.addGestureRecognizer(tapGesture)
//
//        tapGesture.rx.event.bind(onNext: { [weak self] recognizer in
//            self?.view.endEditing(true)
//        }).disposed(by: bag)
        
        NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillShow).subscribe(onNext: { [weak self] (notification) in
//            print(notification.userInfo)
            if let userInfo = notification.userInfo,
                let aValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
                let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double {
//                print(aValue.height)
                if let bottomView = bottomView {
                    UIView.animate(withDuration: duration, animations: {
                        bottomView.snp.updateConstraints({ (make) in
                            make.bottom.equalToSuperview().offset(-aValue.height)
                        })
                    })
                    
                    bottomView.superview?.layoutIfNeeded()
                    
                    self?.tableView.mj_footer.isHidden = true
                }
            }
            
        }).disposed(by: bag)
        
        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillHide).subscribe(onNext: { [weak self] (notification) in
//            print(notification.userInfo)
            if let userInfo = notification.userInfo,
//                let aValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
                let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double {
                if let bottomView = bottomView {
                    UIView.animate(withDuration: duration, animations: {
                        bottomView.snp.updateConstraints({ (make) in
                            make.bottom.equalToSuperview()
                        })
                    }, completion: { (finished) in
                        if finished {
                            self?.tableView.mj_footer.isHidden = false
                        }
                    })
                    
                    bottomView.superview?.layoutIfNeeded()
                }
            }
        }).disposed(by: bag)
        
//        let delegateProxy = RxTextViewDelegateProxy(textView: commentOperationView.commentTextView)
        commentOperationView.commentTextView.delegate = self
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        IQKeyboardManager.shared.enable = false
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        IQKeyboardManager.shared.enable = true
//    }
}

extension CommentListViewController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            let alert = UIAlertController(title: "提示", message: "是否提交评论", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { [weak self] (alertAction) in
                self?.commentVM.requestCommentList(content: textView.text, complete: { (error) in
                    self?.tableView.reloadData()
                    textView.text = ""
                })
            }))
            self.present(alert, animated: true, completion: nil)
        }
        return true
    }
}

extension CommentListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentVM.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellViewModel = self.commentVM.dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellReuseIdentifier(), for: indexPath)
        return cell
    }
}

extension CommentListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellViewModel = self.commentVM.dataSource[indexPath.row]
        (cell as! CellBindViewModelProtocol).bind(with: cellViewModel)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = self.commentVM.dataSource[indexPath.row]
        return tableView.fd_heightForCell(withIdentifier: cellViewModel.cellReuseIdentifier(), cacheBy: indexPath, configuration: { (cell) in
            (cell as! CellBindViewModelProtocol).bind(with: cellViewModel)
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = self.commentVM.dataSource[indexPath.row]
        
        self.view.endEditing(true)
        
        let comment = self.commentVM.comments[indexPath.row]
        
        var contentText = commentOperationView.commentTextView.text ?? ""
        
        do {
            let regex = try NSRegularExpression(pattern: "#.*?#\\s", options: .caseInsensitive)
            let res = regex.matches(in: contentText, options: .init(rawValue: 0), range: NSMakeRange(0, contentText.count))
            for checkingRes in res {
                let result = (contentText as NSString).substring(with: checkingRes.range)
                contentText = contentText.replacingOccurrences(of: result, with: "")
            }
        } catch {
            
        }
        
        commentOperationView.commentTextView.text = "#QUOTE\(comment.floor)# \(contentText)"
        
        // iOS bug: https://github.com/lkzhao/Hero/issues/106 https://github.com/lkzhao/Hero/issues/79
        DispatchQueue.main.async {
            cellViewModel.cellSelected()
        }
        //
    }
}
