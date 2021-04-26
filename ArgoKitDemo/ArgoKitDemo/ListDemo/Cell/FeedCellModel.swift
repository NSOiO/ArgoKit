//
//  FeedCellModel.swift
//  ArgoKitDemo
//
//  Created by Dai on 2021-01-26.
//

import ArgoKit

// view model.
class FeedCellModel: FeedCellModelProtocol {
    @Observable var action: Action = EmptyAction()
    
    var content: String = ""
    var userName = "Emily"
    var userAge = 20
    var placeHolder = "turtlerock"
    var iconURL: URL? = nil
    var photoURLs: [URL] = []
    var time: Int = 1
    var distance: Float = 0.1
    
    @Observable var likes: Int = 0
    @Observable var isLiked: Bool = false
    
    var comments: Int = 0
    var conversation: String = "对话"
    let bag = DisposeBag()
    
    init() {
        self.addListener()
    }
    
    init(action: Observable<Action>) {
        self._action = action
        self.addListener()
    }
    
    private func addListener() {
        self.$isLiked.watch { [weak self] new in
            if new {
                self?.likes += 1
            } else {
                self?.likes -= 1
            }
        }
        .disposed(by: self.bag)

        self.$action.watch(type: FeedCellAction.self) {[weak self] action in
            if case FeedCellAction.likeButtonClick = action {
                self?.isLiked.toggle()
            }
        }.disposed(by: self.bag)
        
    }
}


