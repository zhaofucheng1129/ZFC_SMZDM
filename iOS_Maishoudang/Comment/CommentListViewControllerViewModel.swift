//
//  CommentListViewControllerViewModel.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/30.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import PKHUD

class CommentListViewControllerViewModel: NSObject {
    
    public var dataSource: [CellViewModelProtocol] = []
    
    public var comments: [Comment] = []
    
    private var pageIndex = 1
    
    private let commentableType: String
    private let commentableId: UInt
    
    private var bag = DisposeBag()
    
    init(commentableType:String, commentableId:UInt) {
        self.commentableType = commentableType
        self.commentableId = commentableId
        
        super.init()
    }
    
    func requestNewData(complete:@escaping ((Error?)->Void)) {
        pageIndex = 1
        requestCommentList(pageIndex: pageIndex).subscribe(onNext: { [weak self] (comments) in
                if let strongSelf = self {
                    strongSelf.dataSource = comments.map {
                        if let _ = $0.parent {
                            return ReplyCommentTableViewCellViewModel(comment: $0, cellSelecteCommand: nil)
                        } else {
                            return NormalCommentTableViewCellViewModel(comment: $0, cellSelecteCommand: nil)
                        }
                    }
                    strongSelf.comments = comments
                }
                }, onError: { (error) in
                    DispatchQueue.main.async {
                        HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription),delay: 1.0)
                        complete(error)
                    }
            }, onCompleted: {
                DispatchQueue.main.async {
                    complete(nil)
                }
            }, onDisposed: {
                print("释放")
            }).disposed(by: bag)
    }
    
    func requestNextPageData(complete:@escaping ((Error?)->Void)) {
        requestCommentList(pageIndex: pageIndex + 1).subscribe(onNext: { [weak self] (comments) in
                if let strongSelf = self {
                    let commentCells:[CellViewModelProtocol] = comments.map {
                        if let _ = $0.parent {
                            return ReplyCommentTableViewCellViewModel(comment: $0, cellSelecteCommand: nil)
                        } else {
                            return NormalCommentTableViewCellViewModel(comment: $0, cellSelecteCommand: nil)
                        }
                    }
                    strongSelf.dataSource.append(contentsOf: commentCells)
                    strongSelf.pageIndex += 1
                    
                    strongSelf.comments.append(contentsOf: comments)
                }
            }, onError: { (error) in
                    DispatchQueue.main.async {
                        HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription),delay: 1.0)
                        complete(error)
                    }
            }, onCompleted: {
                DispatchQueue.main.async {
                    complete(nil)
                }
            }).disposed(by: bag)
    }
    
    private func requestCommentList(pageIndex: Int) -> Observable<[Comment]>{
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return msdApiProvider.rx.request(.commentsApi(page: pageIndex, commentableType: commentableType, commentableId: self.commentableId)).map([Comment].self, atKeyPath: nil, using: decoder, failsOnEmptyData: false).asObservable()
    }
    
    public func requestCommentList(content:String, complete:@escaping ((Error?)->Void)) {
        HUD.show(.labeledProgress(title: "提示", subtitle: "发表评论"))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        msdApiProvider.rx.request(.replyCommentApi(content: content, commentableType: commentableType, commentableId: commentableId)).map(Comment.self, atKeyPath: nil, using: decoder, failsOnEmptyData: false).subscribe(onSuccess: { [weak self] (comment) in
            HUD.hide(animated: true)
            if let strongSelf = self {
                if let _ = comment.parent {
                    strongSelf.dataSource.insert(ReplyCommentTableViewCellViewModel(comment: comment, cellSelecteCommand: nil), at: 0)
                } else {
                    strongSelf.dataSource.insert(NormalCommentTableViewCellViewModel(comment: comment, cellSelecteCommand: nil), at: 0)
                }
                strongSelf.comments.insert(comment, at: 0)
            }
            complete(nil)
        }) { (error) in
            HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription),delay: 1.0)
        }.disposed(by: bag)
    }
}
