//
//  FeedListModel.swift
//  ArgoKitDemo
//
//  Created by Dai on 2021-01-26.
//

import ArgoKit

// view model.
class FeedListModel: FeedListModelProtocol {
    @Observable var action: Action = EmptyAction()
    var bag = DisposeBag()

    var name = ""
    var dataSource = DataSource([FeedBaseProtocol]())
}

