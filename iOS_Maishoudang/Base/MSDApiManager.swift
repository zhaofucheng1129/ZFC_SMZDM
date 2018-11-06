//
//  ApiManager.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/7/3.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import Foundation
import Moya

let msdApiProvider = MoyaProvider<MSDApiManager>(plugins: [NetworkLoggerPlugin(verbose: true)])

enum MSDApiManager {
    /// 签到
    case checkInApi
    /// 登陆
    case loginApi(userName: String, passwd: String)
    /// 联合登陆
    case unionLoginApi(provider: String, uid: String, nickName: String, imageUrl: String)
    /// 注册设备
    case deviceRegisterApi
    /// 检查版本
    case appVersionApi
    /// Banner列表
    case galleriesApi
    /// 推荐列表
    case dealsApi(page: Int)
    /// 晒单列表
    case experiencesApi(page: Int)
    /// 发现列表
    case discoveriesApi(page: Int)
    /// 推送列表
    case pushedApi(page: Int)
    /// 详情
    case detailApi(type: recommendType, recommendId:UInt)
    /// 点赞
    case agreeApi(gradableType: String, gradableId: UInt, agreeType: String)
    /// 收藏
    case favoriteApi(favorableType: String, favorableId: UInt)
    /// 评论列表
    case commentsApi(page: Int, commentableType: String, commentableId: UInt)
    /// 回复评论
    case replyCommentApi(content: String, commentableType: String, commentableId: UInt)
    /// 类别列表
    case categoriesListApi
    /// 搜索
    case searchApi(type: recommendType, keyWord: String, page: Int)
    /// 订阅神价
    case subscribeBestPriceApi(isSubscribe: Bool)
    /// 订阅站内通知
    case subscribeNoticeApi(isSubscribe: Bool)
    /// 站内通知列表
    case noticesApi(page: Int)
    /// 清除未读消息
    case readAllMessageApi
}

// MARK: - TargetType Protocol Implementation

extension MSDApiManager: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://www.maishoudang.com/api")!
    }
    
    var path: String {
        switch self {
        case .checkInApi:
            return "/v1/checkins.json"
        case .loginApi:
            return "/v2/sessions"
        case .unionLoginApi:
            return "/v2/sessions/auth"
        case .deviceRegisterApi:
            return "/v1/devices.json"
        case .appVersionApi:
            return "/v1/app_versions/ios.json"
        case .galleriesApi:
            return "/v1/galleries.json"
        case .dealsApi:
            return "/v1/deals.json"
        case .experiencesApi:
            return "/v1/experiences.json"
        case .discoveriesApi:
            return "/v1/discoveries.json"
        case .pushedApi:
            return "/v1/deals/pushed.json"
        case .detailApi(let type, let recommendId):
            switch type {
            case .deal,.deals,.Deal:
                return "/v1/deals/\(recommendId).json"
            case .experience,.experiences,.Experience:
                return "/v1/experiences/\(recommendId).json"
            case .discovery,.discoveries,.Discovery:
                return "/v1/discoveries/\(recommendId).json"
            default:
                return ""
            }
        case .agreeApi:
            return "/v1/grades.json"
        case .favoriteApi:
            return "/v1/favorites.json"
        case .commentsApi,.replyCommentApi:
            return "/v1/comments.json"
        case .categoriesListApi:
            return "/v1/categories.json"
        case .searchApi(let type, let keyWord, _):
            switch type {
            case .deal,.deals,.Deal,.experience,.experiences,.Experience,.discovery,.discoveries,.Discovery:
                return "/v1/search.json"
            case .category:
                return "/v1/categories/\(keyWord).json"
            case .favorites:
                return "/v1/favorites.json"
            }
        case .subscribeBestPriceApi,.subscribeNoticeApi:
            return "/v1/devices/%@.json" //待定
        case .noticesApi:
            return "/v2/notices.json"
        case .readAllMessageApi:
            return "/v2/notices/read_all"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .checkInApi,.loginApi,.unionLoginApi,.deviceRegisterApi,
             .agreeApi,.favoriteApi,.replyCommentApi:
            return .post
        case .appVersionApi,.galleriesApi,.dealsApi,
             .experiencesApi,.discoveriesApi,.pushedApi,
             .detailApi,.commentsApi,.categoriesListApi,.searchApi,.noticesApi:
            return .get
        case .subscribeBestPriceApi,.subscribeNoticeApi,.readAllMessageApi:
            return .put
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return "Half measures are as bad as nothing at all.".data(using: .utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .checkInApi,.appVersionApi,.galleriesApi,.detailApi,.categoriesListApi,.readAllMessageApi:
            return .requestPlain
        case let .loginApi(userName, passwd):
            return .requestJSONEncodable(LoginRequestModel(userName: userName, passwd: passwd))
        case let .unionLoginApi(provider, uid, nickName, imageUrl):
            return .requestJSONEncodable(UnionLoginRequestModel(provider: provider, uid: uid, nickName: nickName, imageUrl: imageUrl))
        case .deviceRegisterApi:
            return .requestJSONEncodable(DeviceRegisterRequestModel())
        case .dealsApi(let page),.experiencesApi(let page),.discoveriesApi(let page),.pushedApi(let page),.noticesApi(let page):
            return .requestParameters(parameters: ["page":page], encoding: URLEncoding.default)
        case let .agreeApi(gradableType, gradableId, agreeType):
            return .requestJSONEncodable(AgreeRequestModel(gradableType: gradableType, gradableId: gradableId, agreeType: agreeType))
        case let .favoriteApi(favorableType, favorableId):
            return .requestJSONEncodable(FavoritesRequestModel(favorableType: favorableType, favorableId: favorableId))
        case let .replyCommentApi(content, commentableType, commentableId):
            return .requestJSONEncodable(ReplyCommentRequestModel(content: content, commentableType: commentableType, commentableId: commentableId))
        case let .commentsApi(page, commentableType, commentableId):
            return .requestJSONEncodable(CommentListRequestModel(page: page, commentableType: commentableType, commentableId: commentableId))
        case let .searchApi(type, keyWord, page):
            switch type {
            case .deal,.deals,.Deal:
                return .requestParameters(parameters: ["search_type":"deal", "page":page, "keyword":keyWord], encoding: URLEncoding.default)
            case .experience,.experiences,.Experience:
                return .requestParameters(parameters: ["search_type":"experience", "page":page, "keyword":keyWord], encoding: URLEncoding.default)
            case .discovery,.discoveries,.Discovery:
                return .requestParameters(parameters: ["search_type":"discovery", "page":page, "keyword":keyWord], encoding: URLEncoding.default)
            case .category,.favorites:
                return .requestParameters(parameters: ["page":page], encoding: URLEncoding.default)
            }
        case .subscribeBestPriceApi(let isSubscribe):
            return .requestJSONEncodable(SubscribeBestPriceRequestModel(subscribeBestPrice: isSubscribe))
        case .subscribeNoticeApi(let isSubscribe):
            return .requestJSONEncodable(SubscribeNoticeRequestModel(subscribeNotice: isSubscribe))
        }
    }
    
    var validationType: ValidationType {
        return .none
    }
    
    var headers: [String : String]? {
        if let token = CacheManager.getAuthorizeToken() {
            return ["Authorization": token]
        } else {
            return nil
        }
    }
}

///推荐文章类型
enum recommendType: String, Codable {
    case deals
    case deal
    case Deal
    
    case experience
    case experiences
    case Experience
    
    case discovery
    case discoveries
    case Discovery
    
    case category
    case favorites
}

/// 登陆请求模型
struct LoginRequestModel: Codable {
    let login: String
    let password: String
    let deviceId: String? //待定
    
    init(userName:String,passwd:String) {
        self.login = userName
        self.password = passwd
        self.deviceId = CacheManager.getDeviceId()
    }
    
    enum CodingKeys: String, CodingKey {
        case login
        case password
        case deviceId = "device_id"
    }
}

/// 联合登陆请求模型
struct UnionLoginRequestModel: Codable {
    let deviceId: String? //待定
    let provider: String
    let uid: String
    let nickName: String
    let imageUrl: String
    
    init(provider: String, uid: String, nickName: String, imageUrl: String) {
        self.provider = provider
        self.uid = uid
        self.nickName = nickName
        self.imageUrl = imageUrl
        self.deviceId = CacheManager.getDeviceId()
    }
    
    enum CodingKeys: String, CodingKey {
        case deviceId = "device_id"
        case provider
        case uid
        case nickName = "nick_name"
        case imageUrl = "image_url"
    }
}

/// 注册设备请求模型
struct DeviceRegisterRequestModel: Codable {
    let osType: String
    
    init() {
        self.osType = "ios"
    }
    
    enum CodingKeys: String, CodingKey {
        case osType = "os_type"
    }
}

/// 点赞请求模型
struct AgreeRequestModel: Codable {
    let gradableType: String
    let gradableId: UInt
    let agreeType: String
    
    enum CodingKeys: String, CodingKey {
        case gradableType = "gradable_type"
        case gradableId = "gradable_id"
        case agreeType = "grade_type"
    }
}

/// 收藏请求模型
struct FavoritesRequestModel: Codable {
    let favorableType: String
    let favorableId: UInt
    
    enum CodingKeys: String, CodingKey {
        case favorableType = "favorable_type"
        case favorableId = "favorable_id"
    }
}

/// 评论列表请求模型
struct CommentListRequestModel: Codable {
    let page: Int
    let commentableType: String
    let commentableId: UInt
    
    enum CodingKeys: String, CodingKey {
        case page
        case commentableType = "commentable_type"
        case commentableId = "commentable_id"
    }
}

/// 回复评论请求模型
struct ReplyCommentRequestModel: Codable {
    let content: String
    let commentableType: String
    let commentableId: UInt
    let source = "ios"
    
    init(content:String, commentableType: String, commentableId: UInt) {
        self.content = content
        self.commentableType = commentableType
        self.commentableId = commentableId
    }
    
    enum CodingKeys: String, CodingKey {
        case content
        case commentableType = "commentable_type"
        case commentableId = "commentable_id"
        case source
    }
}

/// 订阅神价请求模型
struct SubscribeBestPriceRequestModel: Codable {
    let id: String
    let subscribeBestPrice: Bool
    
    init(subscribeBestPrice: Bool) {
        self.subscribeBestPrice = subscribeBestPrice
        self.id = "" ///待定
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case subscribeBestPrice = "subscribe_best_price"
    }
}

/// 订阅站内通知请求模型
struct SubscribeNoticeRequestModel: Codable {
    let id: String
    let subscribeNotice: Bool
    
    init(subscribeNotice: Bool) {
        self.subscribeNotice = subscribeNotice
        self.id = "" ///待定
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case subscribeNotice = "subscribe_notice"
    }
}
