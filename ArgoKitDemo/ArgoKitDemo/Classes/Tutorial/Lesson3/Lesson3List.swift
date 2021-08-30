//
//  Lesson3List.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/10.
//

import ArgoKit

// view model.
protocol Lesson3ListModelProtocol: ViewModelProtocol {
    var dataSource: DataSource<[Lesson3CellModelProtocol]> {get set}
    func resetDataSource()
    func appendDataSource()
}

// view
struct Lesson3List: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: Lesson3ListModelProtocol
    init(model: Lesson3ListModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        List(data: model.dataSource) { cellViewModel in
            cellViewModel.makeView()
        }
        .tableHeaderView {
            headerOrFooterView("refresh") {
                refresh()
            }
        }
        .tableFooterView {
            headerOrFooterView("Load More") {
                loadMore()
            }
        }
        .cellCanEdit({ cellViewModel, indexPath in
            return true
        })
        .trailingSwipeActions { cellViewModel, indexPath in
            let deleteAction = UIContextualAction(style: .normal, title: "删除") { action, sourceView, completeHandler in
                deleteRow(indexPath)
                completeHandler(true)
            }
            
            var actions = [deleteAction]
            deleteAction.backgroundColor = .red
            if !cellViewModel.isTop {
                let topAciton = UIContextualAction(style: .normal, title: "置顶") { action, sourceView, completeHandler in
                    topRow(indexPath)
                    completeHandler(true)
                }
                actions.append(topAciton)
            }
            let config = ListSwipeActionsConfiguration(actions: actions)
            config.performsFirstActionWithFullSwipe = false
            return config
        }
    }
}

extension Lesson3List {
    
    private func headerOrFooterView(_ text: String, _ tapAction: @escaping () -> Void) -> View {
        let view = HStack {
            Text(text)
                .height(40)
                .margin(edge: .horizontal, value: 15)
                .backgroundColor(red: 170, green: 170, blue: 170)
                .textColor(.white)
                .textAlign(.center)
                .cornerRadius(5)
                .grow(1)
                .onTapGesture {
                    tapAction()
                }
        }
        return view
    }
    
    private func refresh() {
        model.resetDataSource()
        model.dataSource.apply()
    }
    
    private func loadMore() {
        model.appendDataSource()
        model.dataSource.apply()
    }
    
    private func deleteRow(_ indexPath: IndexPath) {
        model.dataSource.delete(at: indexPath)
        model.dataSource.apply()
    }
    
    private func topRow(_ indexPath: IndexPath) {
        if let cellViewModel =  model.dataSource.value(at: indexPath) {
            cellViewModel.isTop = true
            model.dataSource.move(at: indexPath, to: IndexPath(row: 0, section: indexPath.section))
            // 当使用带动画的 appley 时，不调用 reloadData
            model.dataSource.apply(with:.left)
            // 实际调用 reloadData
//            model.dataSource.apply()
        }
    }
}

extension Lesson3ListModelProtocol {
    func makeView() -> ArgoKit.View {
        Lesson3List(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class Lesson3ListModelPreviews: Lesson3ListModelProtocol {
    var dataSource: DataSource<[Lesson3CellModelProtocol]> = DataSource([Lesson3CellModelPreviews]())
    
    init() {
        resetDataSource()
    }
    
    func resetDataSource() {
        dataSource.clear()
        appendDataSource()
    }
    
    func appendDataSource() {
        for _ in 0...9 {
            let currentIndex = dataSource.count()
            let model = Lesson3CellModelPreviews()
            model.nameStr += "\(currentIndex)"
            let imgNum = currentIndex % 10
            let avatarImg = "img_avatar_" + "\(imgNum)"
            model.avatarImg = avatarImg
            dataSource.append(model)
        }
    }
}

import ArgoKitPreview
import ArgoKitComponent
import SwiftUI
@available(iOS 13.0.0, *)
private func argoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct Lesson3ListPreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            argoKitRender {
                Lesson3ListModelPreviews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

