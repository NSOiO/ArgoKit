//
//  ListCellTestsModel.swift
//  ArgoKitDemo
//
//  Created by Dai on 2021-01-13.
//

import Foundation
import ArgoKit

// view model.
class ListCellTestsModel: ListCellTestsModelProtocol {
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
    
    //点击button，likes数字自动修改
    lazy var watchIsLiked = self.$isLiked.watch { [weak self] new in
        if new {
            self?.likes += 1
        } else {
            self?.likes -= 1
        }
    }

    func likeButtonAction() {
        self.isLiked.toggle()
        self.comments += 1
    }
}


