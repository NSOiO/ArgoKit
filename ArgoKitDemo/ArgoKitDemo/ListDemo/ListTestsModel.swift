//
//  ListTestsModel.swift
//  ArgoKitDemo
//
//  Created by Dai on 2021-01-21.
//

import Foundation
import ArgoKit

class ListTestsModel: ListTestsModelProtocol {
    var name = ""
    var dataSource = DataSource([ListCellTestsModelProtocol]())
}
