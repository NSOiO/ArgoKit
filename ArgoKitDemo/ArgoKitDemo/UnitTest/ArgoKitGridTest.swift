//
//  ArgoKitGridTest.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/17.
//

import ArgoKit

// view model.
class ArgoKitGridTestModel :ArgoKitIdentifiable{
    deinit {
        print("ArgoKitGridTestModel")
    }
    let titiles = ["chincoteague.jpgchincoteague.jpgchincoteague.jpgchincoteague.jpgchincoteague.jpg","icybay.jpg","silversalmoncreek.jpg","umbagog.jpg","hiddenlakechincoteague.jpgchincoteague.jpgchincoteague.jpg.jpg"]
    let images = ["chincoteague.jpg","icybay.jpg","silversalmoncreek.jpg","umbagog.jpg","hiddenlake.jpg"]
    let messages = ["11","22","33","44","55"]
    var nodeQueue:DispatchQueue = DispatchQueue(label: "com.argokit.create.list")
    @DataSource var dataSource1:[[ArgoKitGridCellTestModel]] = [[ArgoKitGridCellTestModel]]()
    
    @DataSource var dataSource2:[ArgoKitGridCellTestModel] = [ArgoKitGridCellTestModel]()
    
    @DataSource var headerSource:[ArgoKitGridCellTestModel] = [ArgoKitGridCellTestModel]()
    
    var page = 1
    
    init() {
        reloadMoreData()
    }
    
    func reloadMoreData(){
        nodeQueue.async {[weak self] in
            self?._reloadMoreData()
            DispatchQueue.main.async {[weak self] in
                self?.$dataSource1.apply()
            }
        }
    }
    func _reloadMoreData(){
        var dataSource = [[ArgoKitGridCellTestModel]]()
        for index in 0..<1{
            let idetifier = "session:\(page + index)"
            let headerModel = ArgoKitGridCellTestModel()
            headerModel.headerName = idetifier
            $headerSource.append(headerModel)
           
            var subDataSource = [ArgoKitGridCellTestModel]()
            for j in 0..<20{
                let item = ArgoKitGridCellTestModel()
                item.headerName = "Hello, ArgoKit!"
                item.imagePath = images[j%5]
                subDataSource.append(item)
            }
            $dataSource2.append(contentsOf: subDataSource)
            dataSource.append(subDataSource)
        }
       
        page = page + 1
        $dataSource1.append(contentsOf: dataSource)
    }

}

class ArgoKitGridCellTestModel :ArgoKitIdentifiable{
    deinit {
        print("ArgoKitGridCellTestModel")
    }
    var _reuseIdentifier: String = "ArgoKitGridCellTestModel"
    var reuseIdentifier: String{
        _reuseIdentifier
    }
    @Observable var headerName = "titletitletitle"
    @Observable var imagePath = "icybay.jpg"
    @Observable var fontSize:CGFloat = 14.0
    var text:Text?
   
}

class ArgoKitGridHeaderTestModel:ArgoKitIdentifiable {
    var _reuseIdentifier: String = "ArgoKitGridHeaderTestModel"
    var reuseIdentifier: String{
        _reuseIdentifier
    }
    var headerName = "title"
}

// view
struct ArgoKitGridTest: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitGridTestModel
    init(model: ArgoKitGridTestModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
      
        Grid(waterfall: false,data:model.$dataSource1){ data in

            Text(data.headerName)
                .lineLimit(0)
                .textAlign(.center)
                .backgroundColor(.red)
//                .font(style:.bold)
            Image(data.imagePath)
                .aspect(ratio: 1)
                .circle()
                .onTapGesture {
//                    data.fontSize = data.fontSize + 1
                    data.headerName = data.headerName + "csdcsdc？"
                }
        }
//        .grow(0.0)
        .columnCount(3)
        .columnSpacing(10)
        .lineSpacing(10)
        .layoutInset(top: 0, left: 10, bottom: 0, right: 10)
        .cellWillAppear{ (_, indexpath) in
        
        }
        .cellDidDisappear({ (data, indexpath) in
        })
        .cellSelected({ (data, indexpath) in
        })
        .cellDeselected({ (data, indexpath) in
        })
        .willBeginDragging {
        
        }
        .sectionFooter(data:model.$headerSource) { data -> View in
            Text(data.headerName)
                .textAlign(.center)
                .backgroundColor(.gray)
                .lineLimit(0)
                .font(size:20)

        }
        .footerWillAppear({ (data, indexpath) in
            print("footerWillAppear==indexpath:\(indexpath)")
        })
        .footerDidDisappear({ (data, indexpath) in
            print("footerDidDisappear==indexpath:\(indexpath)")
        })
        .refreshFooterView { () -> RefreshFooterView in
            RefreshFooterView {[model1 = model] refresh in
                model1.reloadMoreData()
                refresh?.endRefreshing()
                refresh?.resetNoMoreData()
            } _: { () -> View in
                Text("refresh_footer").backgroundColor(.red)
                Image("chilkoottrail.jpg")
                    .width(30)
                    .aspect(ratio: 1)
                    .circle()
            }
            .backgroundColor(.orange)
            .alignItems(.center)
            .autoRefreshOffPage(3)
        }
        
    }

 
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ArgoKitGridTestModel_Previews:  ArgoKitGridTestModel {
    override init() {
        super.init()
    }
}

@available(iOS 13.0.0, *)
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct ArgoKitGridTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitRender {
            ArgoKitGridTest(model: ArgoKitGridTestModel_Previews()).grow(1)
        }
    }
}
#endif
