//
//  FeedDetailViewModel.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/7.
//

import Foundation
import ArgoKit

class FeedDetailViewModel: FeedDetailViewModelProtocol {
    var avatarImg = "img_avatar_1"
    var name: String = "魔女同同"
    var isVip: Bool = true
    var userExtraInfo: String = "很高兴认识你"
    var feedContent: String = "今天天气真不错😄。"
    var feedImg: String = "img_detail"
    var isLiked: Bool = false {
        didSet {
            likeCount = isLiked ? likeCount + 1 : likeCount - 1
            likeImg = isLiked ? "liked" : "like"
        }
    }
    var likeCount: Int = 0 {
        didSet {
            likeCountStr = likeCount > 0 ? String(likeCount) : "点赞"
        }
    }
    @Observable var likeCountStr: String = "点赞"
    @Observable var likeImg: String = "like"
    var commentCount: Int = 0 {
        didSet {
            commentCountStr = commentCount > 0 ? String(commentCount) : "评论"
        }
    }
    @Observable var commentCountStr: String = "评论"
    var contentImgAciton: () -> Void = {}
    var moreAciton: () -> Void = {}
    var likeAction: () -> Void = {}
    var commentAction: () -> Void = {}
}
