//
//  ArgoKitGridTest.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/17.
//

import ArgoKit

// view model.
class ArgoKitGridTestModel {
    let titiles = ["chincoteague.jpgchincoteague.jpgchincoteague.jpgchincoteague.jpgchincoteague.jpg","icybay.jpg","silversalmoncreek.jpg","umbagog.jpg","hiddenlakechincoteague.jpgchincoteague.jpgchincoteague.jpg.jpg"]
    let images = ["chincoteague.jpg","icybay.jpg","silversalmoncreek.jpg","umbagog.jpg","hiddenlake.jpg"]
    let messages = ["11","22","33","44","55"]
    
    @DataSource var dataSource1:[[ArgoKitGridCellTestModel]] = [[ArgoKitGridCellTestModel]]()
    
    @DataSource var dataSource2:[ArgoKitGridCellTestModel] = [ArgoKitGridCellTestModel]()
    
    @DataSource var headerSource:[ArgoKitGridCellTestModel] = [ArgoKitGridCellTestModel]()
    
    var page = 1
    
    init() {
        reloadMoreData()
    }
   
    func reloadMoreData(){
        for index in 0..<20 {
            let idetifier = "session:\(page + index)"
            let headerModel = ArgoKitGridCellTestModel()
            headerModel.headerName = idetifier
            headerSource.append(headerModel)
           
            var subDataSource = [ArgoKitGridCellTestModel]()
            for index in 0..<10{
                let item = ArgoKitGridCellTestModel()
                item.headerName = "点击图片改变文本内容"
                item.imagePath = images[index%5]
                subDataSource.append(item)
                dataSource2.append(item)
            }
            dataSource1.append(subDataSource)
           
        }
        page = page + 1
    }
    

}

class ArgoKitGridCellTestModel :ArgoKitIdentifiable{
    var _reuseIdentifier: String = "ArgoKitGridCellTestModel"
    var reuseIdentifier: String{
        _reuseIdentifier
    }
    @Property var headerName = "title"
    @Property var imagePath = "icybay.jpg"
    
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
    @Alias var grid:Grid<ArgoKitGridCellTestModel>?
    @Alias var footerView:RefreshFooterView?
    init(model: ArgoKitGridTestModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        /*
        Grid(){
            Text("dsa")
                .lineLimit(0)
                .textAlign(.center)
            Image("icybay.jpg")
                    .aspect(ratio: 1)
                    .circle()
                    .onTapGesture {

                    }
            Text("scsdcsd")
            Image("icybay.jpg")
                    .aspect(ratio: 1)
                    .circle()
                    .onTapGesture {

                    }
            Image("icybay.jpg")
                    .aspect(ratio: 1)
                    .circle()
                    .onTapGesture {

                    }
            Image("icybay.jpg")
                        .aspect(ratio: 1)
                        .circle()
                        .onTapGesture {

                        }
            Image("icybay.jpg")
                            .aspect(ratio: 1)
                            .circle()
                            .onTapGesture {

                            }
            Text("scsdcsd")
            Image("icybay.jpg")
                    .aspect(ratio: 1)
                    .circle()
                    .onTapGesture {

                    }
            Image("icybay.jpg")
                    .aspect(ratio: 1)
                    .circle()
                    .onTapGesture {

                    }
            Image("icybay.jpg")
                                .aspect(ratio: 1)
                                .circle()
                                .onTapGesture {

                                }

        }
        .grow(1.0)
        .columnCount(3)
        .columnSpacing(5)
        .sectionHeader { () -> View in
            Text("scsdcsd").backgroundColor(.yellow)
        }
 */
       
        Grid(waterfall: false,data:model.$dataSource1){ data in

            Text(data.headerName)
                .lineLimit(0)
                .textAlign(.center)

            Image(data.imagePath)
                .aspect(ratio: 1)
                .circle()
                .onTapGesture {
                   
                }

        }
        
        .grow(1.0)
        .columnCount(3)
        .columnSpacing(10)
        .lineSpacing(10)
        .layoutInset(top: 0, left: 10, bottom: 0, right: 10)
        .cellWillAppear{ (_, indexpath) in
        
        }
        .cellDidDisappear({ (data, indexpath) in
        })
        .cellSelected({ (data, indexpath) in
            data.headerName = "chincoteague.jpgchincoteague.jpgchincoteague.jpgchincoteague.jpgchincoteague.jpg"
            data.imagePath = "icybay.jpg"
//            AlertView(title: data.headerName, message: data.headerName, preferredStyle: UIAlertController.Style.alert)
//            .textField()
//            .destructive(title: "确认") { text in
//                print(text ?? "")
//            }
//            .cancel(title: "取消") {}
//            .show()
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

        }
        .footerWillAppear({ (data, indexpath) in
            print("footerWillAppear==indexpath:\(indexpath)")
        })
        .footerDidDisappear({ (data, indexpath) in
            print("footerDidDisappear==indexpath:\(indexpath)")
        })
        .refreshFooterView { () -> RefreshFooterView in
            RefreshFooterView {refresh in
                model.reloadMoreData()
                model.$dataSource2.reloadData()
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
            .alias(variable: $footerView)
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
