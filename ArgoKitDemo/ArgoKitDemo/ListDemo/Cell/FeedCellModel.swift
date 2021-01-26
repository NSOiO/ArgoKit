//
//  FeedCellModel.swift
//  ArgoKitDemo
//
//  Created by Dai on 2021-01-26.
//

import ArgoKit

// view model.
class FeedCellModel: FeedCellModelProtocol,FeedBaseProtocol {
    var content: String = ""
    var userName = "Emily"
    var userAge = 20
    var placeHolder = "turtlerock"
    var iconURL: URL? = nil
    var photoURLs: [URL] = []
    var time: Int = 1
    var distance: Float = 0.1
    
    @Property var likes: Int = 0
    @Property var isLiked: Bool = false
    
    var comments: Int = 0
    var conversation: String = "对话"
    let bag = DisposeBag()
    
    init() {
        self.$isLiked.watch { [weak self] new in
            if new {
                self?.likes += 1
            } else {
                self?.likes -= 1
            }
        }
        .disposed(by: self.bag)
    }

    func likeButtonAction() {
        self.isLiked.toggle()
    }
}

