//
//  List.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

public struct List : View {

    private var tableView : UITableView
    private var pNode : ArgoKitTableNode
    
    public var body: View {
        self
    }
    
    public var type: ArgoKitNodeType {
        .single(pNode)
    }
    
    public var node: ArgoKitNode? {
        pNode
    }
    
    private init(style: UITableView.Style?) {
        tableView = UITableView(frame: .zero, style: style ?? .plain)
        pNode = ArgoKitTableNode(view: tableView)
    }
    
    public init(style: UITableView.Style? = .plain, @ArgoKitViewBuilder content: () -> View) {
        self.init(style: style)
        let container = content()
        if let nodes = container.type.viewNodes() {
            self.pNode.nodeList = nodes
        }
    }

    public init(_ style: UITableView.Style? = .plain, data: [Any], @ArgoKitViewBuilder rowContent: @escaping (Any) -> View) {
        self.init(style: style)
        self.pNode.dataList = data
        self.pNode.buildNodeFunc = rowContent
    }
}
