//
//  List.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

public struct List : ScrollView {

    private var tableView : UITableView
    private var pNode : ArgoKitTableNode
    
    public var body: View {
        self
    }
    
    public var scrollView: UIScrollView {
        tableView
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
            self.pNode.nodeList = [nodes]
        }
    }

    public init(_ style: UITableView.Style? = .plain, data: [Any], @ArgoKitViewBuilder rowContent: @escaping (Any) -> View) {
        self.init(style: style)
        if (data.first as? Array<Any>) != nil {
            self.pNode.dataList = data as? [[Any]]
        } else {
            self.pNode.dataList = [data]
        }
        self.pNode.buildNodeFunc = rowContent
    }
}

extension List {
    
    public func estimatedRowHeight(_ value: CGFloat) -> Self {
        tableView.estimatedRowHeight = value;
        return self
    }

    public func estimatedSectionHeaderHeight(_ value: CGFloat) -> Self {
        tableView.estimatedSectionHeaderHeight = value;
        return self
    }
    
    public func estimatedSectionFooterHeight(_ value: CGFloat) -> Self {
        tableView.estimatedSectionFooterHeight = value;
        return self
    }

    public func separatorInset(_ value: UIEdgeInsets) -> Self {
        tableView.separatorInset = value;
        return self
    }

    @available(iOS 11.0, *)
    public func separatorInsetReference(_ value: UITableView.SeparatorInsetReference) -> Self {
        tableView.separatorInsetReference = value;
        return self
    }

    public func backgroundView(_ value: UIView?) -> Self {
        tableView.backgroundView = value;
        return self
    }
    
    public func scrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) -> Self {
        tableView.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
        return self
    }

    public func scrollToNearestSelectedRow(at scrollPosition: UITableView.ScrollPosition, animated: Bool) -> Self {
        tableView.scrollToNearestSelectedRow(at: scrollPosition, animated: animated)
        return self
    }
    
    public func setEditing(_ editing: Bool, animated: Bool) -> Self {
        tableView.setEditing(editing, animated: animated)
        return self
    }

    public func allowsSelection(_ value: Bool) -> Self {
        tableView.allowsSelection = value;
        return self
    }

    public func allowsSelectionDuringEditing(_ value: Bool) -> Self {
        tableView.allowsSelectionDuringEditing = value;
        return self
    }
    
    public func allowsMultipleSelection(_ value: Bool) -> Self {
        tableView.allowsMultipleSelection = value;
        return self
    }

    public func allowsMultipleSelectionDuringEditing(_ value: Bool) -> Self {
        tableView.allowsMultipleSelectionDuringEditing = value;
        return self
    }
    
    public func selectRow(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableView.ScrollPosition) -> Self {
        tableView.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition);
        return self
    }

    public func deselectRow(at indexPath: IndexPath, animated: Bool) -> Self {
        tableView.deselectRow(at: indexPath, animated: animated);
        return self
    }

    public func sectionIndexMinimumDisplayRowCount(_ value: Int) -> Self {
        tableView.sectionIndexMinimumDisplayRowCount = value;
        return self
    }

    public func sectionIndexColor(_ value: UIColor?) -> Self {
        tableView.sectionIndexColor = value;
        return self
    }

    public func sectionIndexBackgroundColor(_ value: UIColor?) -> Self {
        tableView.sectionIndexBackgroundColor = value;
        return self
    }

    public func sectionIndexTrackingBackgroundColor(_ value: UIColor?) -> Self {
        tableView.sectionIndexTrackingBackgroundColor = value;
        return self
    }

    public func separatorStyle(_ value: UITableViewCell.SeparatorStyle) -> Self {
        tableView.separatorStyle = value;
        return self
    }

    public func separatorColor(_ value: UIColor?) -> Self {
        tableView.separatorColor = value;
        return self
    }
    
    @available(iOS 8.0, *)
    public func separatorEffect(_ value: UIVisualEffect?) -> Self {
        tableView.separatorEffect = value;
        return self
    }

    @available(iOS 9.0, *)
    public func cellLayoutMarginsFollowReadableWidth(_ value: Bool) -> Self {
        tableView.cellLayoutMarginsFollowReadableWidth = value;
        return self
    }

    @available(iOS 11.0, *)
    public func insetsContentViewsToSafeArea(_ value: Bool) -> Self {
        tableView.insetsContentViewsToSafeArea = value;
        return self
    }
    
    public func tableHeaderView(@ArgoKitViewBuilder headerContent: () -> View) -> Self {
        let container = headerContent()
        self.pNode.tableHeaderNode = container.type.viewNode()
        return self
    }
    
    public func tableFooterView(@ArgoKitViewBuilder footerContent: () -> View) -> Self {
        let container = footerContent()
        self.pNode.tableFooterNode = container.type.viewNode()
        return self
    }
    
    @available(iOS 9.0, *)
    public func remembersLastFocusedIndexPath(_ value: Bool) -> Self {
        tableView.remembersLastFocusedIndexPath = value;
        return self
    }

    @available(iOS 14.0, *)
    public func selectionFollowsFocus(_ value: Bool) -> Self {
        tableView.selectionFollowsFocus = value;
        return self
    }
    
    @available(iOS 11.0, *)
    public func dragInteractionEnabled(_ value: Bool) -> Self {
        tableView.dragInteractionEnabled = value;
        return self
    }
}
