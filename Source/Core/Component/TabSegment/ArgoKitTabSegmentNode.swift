//
//  ArgoKitTabSegmentNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/30.
//

import Foundation

class ArgoKitTabSegmentNode: ArgoKitNode {

    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let view = UIScrollView(frame: frame)
        view.showsHorizontalScrollIndicator = false
        return view
    }
}
