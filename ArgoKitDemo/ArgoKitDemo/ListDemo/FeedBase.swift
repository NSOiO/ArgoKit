//
//  FeedBase.swift
//  ArgoKitDemo
//
//  Created by Dai on 2021-01-26.
//

import Foundation
import ArgoKit

protocol FeedBaseProtocol: ViewModelProtocol {
    
}

extension ADCellModel: FeedBaseProtocol{}
extension FeedCellModel: FeedBaseProtocol{}
