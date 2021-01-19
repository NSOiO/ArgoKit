//
//  ListCellTestsViewModel.swift
//  ArgoKitDemo
//
//  Created by Dai on 2021-01-13.
//

import Foundation
import ArgoKit

protocol EventBus {
    func likeButtonAction()
}

// view model.
class ListCellTestsViewModel: ListCellTestsModelProtocol {
//    var reuseIdentifier: String = "cell"
    var title: String = ""
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
    
    lazy var watchIsLiked = self.$isLiked.watch { [weak self] new in
        if new {
            self?.likes += 1
        } else {
            self?.likes -= 1
        }
    }
    
    func isLikedChange(newValue: Bool) {
        
    }

    func likeButtonAction() {
        self.isLiked.toggle()
        self.comments += 1
    }
    
    func makeView() -> View {
        ListCellTests(model: self)
    }
}


