//
//  ArgoRenderList.swift
//  ArgoKitPreview
//
//  Created by Dai on 2020-12-11.
//

#if canImport(SwiftUI)
import Foundation
import UIKit
import SwiftUI
import ArgoKit

//var host: UIHostingController?
var hostView: HostView?
var current_tables = [UITableView: (UITableViewDataSource & UITableViewDelegate)]()

@available(iOS 13.0, *)
public struct ArgoRender: UIViewRepresentable {
    var view: UIView
//    let innerVStack: VStack
//    var previewService: listPreviewService
    
    public init (@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) {
//        self.innerVStack = VStack(builder)
        self.view = Self.createView(builder())
//        self.previewService = listPreviewService()
//        ArgoKitInstance.registerPreviewService(previewService: self.previewService)
    }
    
    /*
    static func createView(_ content: View) -> UIView {
        let ss = UIScreen.main.bounds.size
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ss.width, height: ss.height))
        
        let host = ArgoKit.HostView(view) {
            content.grow(1)
        }
        let size = view.frame.size
        host.height(.init(size.height)).width(.init(size.width  ))
        hostView = host
        _ = host.applyLayout()
        return view
    }
    */
    
    static func createView(_ content: View) -> UIView {
        let ss = UIScreen.main.bounds.size
        let view = UIHostingView(content: content, frame: .init(origin: .zero, size: ss))
//        view.backgroundColor = .lightGray
        return view
    }
    
    public func makeUIView(context: Context) -> UIView {
        for(table, coor) in current_tables {
            table.dataSource = coor
            table.delegate = coor
        }
        return self.view
    }
    
    public func makeCoordinator() -> (UITableViewDataSource & UITableViewDelegate)? {
        preview_coordinator()
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        for(table, coor) in current_tables {
            table.dataSource = coor
            table.delegate = coor
        }
        print(uiView)
    }
}

class preview_coordinator: NSObject, UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let coor = current_tables[tableView] {
            let c = coor.tableView(tableView, numberOfRowsInSection: section)
            return c
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let coor = current_tables[tableView] {
            return coor.tableView(tableView, cellForRowAt: indexPath)
        }
        return UITableViewCell.init(style: .subtitle, reuseIdentifier: "dd")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let coor = current_tables[tableView] {
            return coor.tableView?(tableView, heightForRowAt: indexPath) ?? 20
        }
        return 20
    }
}



public class listPreviewService: ArgoKitListPreviewService {
    public func register(table: UITableView, coordinator: UITableViewDataSource & UITableViewDelegate) {
//        current_preview_list = table
//        current_preview_list_coordinator = coordinator
        current_tables[table] = coordinator
    }
    public init() {}
}

//@available(iOS 13.0.0, *)
//public struct Preview: SwiftUI.View {
//    private var render: ArgoRender
//    public var body: ArgoRender { render }
//    public init(@ArgoKitViewBuilder _ builder:@escaping () -> ArgoKit.View) {
//        self.render = ArgoRender(builder: builder)
//    }
//}


#endif
