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
    
    var dataSource = [[ArgoKitGridCellTestModel]]()
    @DataSource var headerSource:[ArgoKitGridCellTestModel] = [ArgoKitGridCellTestModel]()
    
    var page = 1
    
    init() {
//        dataSource1 = [[ArgoKitGridCellTestModel]]()
//        headerSource = [ArgoKitGridCellTestModel]()
        reloadMoreData()
    }
   
    func reloadMoreData(){
        for index in 0..<page {
            let idetifier = "session:\(page + index)"
            let headerModel = ArgoKitGridCellTestModel()
            headerModel.headerName = idetifier
            headerSource.append(headerModel)
           
            var subDataSource = [ArgoKitGridCellTestModel]()
            for index in 0..<100{
                let item = ArgoKitGridCellTestModel()
                item.headerName = titiles[index%5]
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
    var headerName = "title"
    var imagePath = "icybay.jpg"
    
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
       
        
//        Grid(){
//            Text("dsa")
//                .lineLimit(0)
//                .textAlign(.center)
//
//            Image("icybay.jpg")
//                .aspect(ratio: 1)
//                .circle()
//                .onTapGesture {
//
//                }
//            Image("icybay.jpg")
//                .aspect(ratio: 1)
//                .circle()
//                .onTapGesture {
//
//                }
//            Image("icybay.jpg")
//                .aspect(ratio: 1)
//                .circle()
//                .onTapGesture {
//
//                }
//            Text("scsdcsd")
//            Image("icybay.jpg")
//                    .aspect(ratio: 1)
//                    .circle()
//                    .onTapGesture {
//
//                    }
//            Image("icybay.jpg")
//                    .aspect(ratio: 1)
//                    .circle()
//                    .onTapGesture {
//
//                    }
//            Image("icybay.jpg")
//                    .aspect(ratio: 1)
//                    .circle()
//                    .onTapGesture {
//
//                    }
//            Text("scsdcsd")
//            Image("icybay.jpg")
//                    .aspect(ratio: 1)
//                    .circle()
//                    .onTapGesture {
//
//                    }
//            Image("icybay.jpg")
//                    .aspect(ratio: 1)
//                    .circle()
//                    .onTapGesture {
//
//                    }
//            Image("icybay.jpg")
//                    .aspect(ratio: 1)
//                    .circle()
//                    .onTapGesture {
//
//                    }
//            Text("scsdcsd")
//            Image("icybay.jpg")
//                    .aspect(ratio: 1)
//                    .circle()
//                    .onTapGesture {
//
//                    }
//            Image("icybay.jpg")
//                    .aspect(ratio: 1)
//                    .circle()
//                    .onTapGesture {
//
//                    }
//            Image("icybay.jpg")
//                        .aspect(ratio: 1)
//                        .circle()
//                        .onTapGesture {
//
//                        }
//            Image("icybay.jpg")
//                            .aspect(ratio: 1)
//                            .circle()
//                            .onTapGesture {
//
//                            }
//            Text("scsdcsd")
//            Image("icybay.jpg")
//                    .aspect(ratio: 1)
//                    .circle()
//                    .onTapGesture {
//
//                    }
//            Image("icybay.jpg")
//                    .aspect(ratio: 1)
//                    .circle()
//                    .onTapGesture {
//
//                    }
//            Image("icybay.jpg")
//                        .aspect(ratio: 1)
//                        .circle()
//                        .onTapGesture {
//
//                        }
//            Image("icybay.jpg")
//                            .aspect(ratio: 1)
//                            .circle()
//                            .onTapGesture {
//
//                            }
//            Image("icybay.jpg")
//                                .aspect(ratio: 1)
//                                .circle()
//                                .onTapGesture {
//
//                                }
//
//        }
//        .grow(1.0)
//        .columnCount(3)
//        .columnSpacing(5)
//        .sectionHeader { () -> View in
//            Text("scsdcsd").backgroundColor(.yellow)
//        }
       
        Grid(waterfall: true,data:model.$dataSource2){ data in

            Text(data.headerName)
                .lineLimit(0)
                .textAlign(.center)

            Image(data.imagePath)
                .aspect(ratio: 1)
                .circle()
                .onTapGesture {

                }

        }
//        .alias(variable: $grid)
//
        .grow(1.0)
        .columnCount(3)
        .columnSpacing(5)
        .sectionHeader(data:model.$headerSource) { data -> View in
            Text(data.headerName)
                .textAlign(.center)
                .backgroundColor(.gray)
                .lineLimit(0)

        }
        .refreshFooterView { () -> RefreshFooterView in
            RefreshFooterView {
                model.reloadMoreData()
                model.$dataSource2.reloadData()
                footerView?.endRefreshing()
                footerView?.resetNoMoreData()
            } _: { () -> View in
                Text("refresh_footer").backgroundColor(.red)
                Image("chilkoottrail.jpg")
                    .width(50)
                    .aspect(ratio: 1)
                    .circle()
            }
            .backgroundColor(.orange)
            .alignItems(.center)
            .alias(variable: $footerView)
            .autoRefreshOffPage(3)
        
        }
        /*
//        .lineSpacing(5)
//        .layoutInset(top: 10, left:10, bottom: 10, right: 10)
//        .showsScrollIndicator(true)
//        .cellWillAppear{ (_, indexpath) in
//
//        }
//        .cellDidDisappear({ (data, indexpath) in
//        })
//        .cellSelected({ (data, indexpath) in
//        })
//        .cellDeselected({ (data, indexpath) in
//        })
//        .willBeginDragging {
//
//        }
   
        .headersPinToVisibleBounds(true)
//        .sectionFooter([ArgoKitGridHeaderTestModel()]){data->View in
//            Text(data.headerName)
//                .textAlign(.center)
//                .backgroundColor(.yellow)
//                .height(40)
//        }
        
//        // ios13及以上
//        .contextMenuConfiguration(title: "title") { (data, indexPath) -> [UIAction]? in
//            // 第一个
//            let favorite = UIAction(title: "Favorite", image: UIImage(systemName: "heart.fill")) { action in
//                print("favorite")
//            }
//
//            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up.fill")) { action in
//                print("share")
//            }
//
//            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), attributes: [.destructive]) { action in
//                print("delete")
//            }
//            return [favorite,share,delete]
//        }
//        .previewForContextMenu { () -> View in
//            HStack{
//                Text("previewForContextMenu")
//            }
//            .backgroundColor(.red)
//            .height(100)
//        }
        .refreshHeaderView { () -> RefreshHeaderView in
            RefreshHeaderView {
                
            } _: { () -> View in
                Text("refresh_header").alignSelf(.center)
            }
            .backgroundColor(.red)
        }
        .refreshFooterView { () -> RefreshFooterView in
            RefreshFooterView {
                model.reloadMoreData()
                grid?.reloadData()
                footerView?.endRefreshing()
                footerView?.resetNoMoreData()
            } _: { () -> View in
                Text("refresh_footer").backgroundColor(.red)
                Image("chilkoottrail.jpg")
                    .width(50)
                    .aspect(ratio: 1)
                    .circle()
            }
            .backgroundColor(.orange)
            .alignItems(.center)
            .alias(variable: $footerView)
            .autoRefreshOffPage(3)
        
        } */
//        .contentWidth(300)
//        .scrollEnabled(true)
//        .scrollDirection(UICollectionView.ScrollDirection.vertical)
//        .showsScrollIndicator(true)
        

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
