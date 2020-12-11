//
//  ListPreview.swift
//  ArgoKit
//
//  Created by Dai on 2020-12-11.
//

import Foundation

public protocol ArgoKitListPreviewService {
    func register(table: UITableView, coordinator: UITableViewDataSource & UITableViewDelegate)
}


