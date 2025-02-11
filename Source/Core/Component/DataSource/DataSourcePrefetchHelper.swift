//
//  DataSourcePrefetchHelper.swift
//  ArgoKit
//
//  Created by Bruce on 2021/1/28.
//

import Foundation
class DataSourcePrefetchModel<D>{
    var dataSourceHelper: DataSourceHelper<D>?
    var indexPaths:[IndexPath]?
    var width:CGFloat = UIScreen.main.bounds.width
    init(_ dataSourceHelper:DataSourceHelper<D>?,indexPaths:[IndexPath]?) {
        self.dataSourceHelper = dataSourceHelper
        self.indexPaths = indexPaths
    }
}

class DataSourcePrefetchHelper<D>{
    public init() {
        startRunloop()
    }
    var observe:CFRunLoopObserver? = nil
    var prefetchModels:NSMutableArray = NSMutableArray()
    func startRunloop() -> Void {
        if observe == nil {
            let runloop:CFRunLoop = CFRunLoopGetMain()
            observe = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.beforeWaiting.rawValue, true, 1, {[weak self] (observer, activity) in
                self?.runOperation()
            })
            if let _ =  observe {
                CFRunLoopAddObserver(runloop, observe, CFRunLoopMode.commonModes)
            }
        }
    }
    
    func stopRunloop() -> Void {
        if let _ =  observe {
            if CFRunLoopContainsObserver(CFRunLoopGetMain(), observe, CFRunLoopMode.commonModes) {
                CFRunLoopRemoveObserver(CFRunLoopGetMain(),observe, CFRunLoopMode.commonModes)
            }
            observe = nil
        }
    }
    
    func addPrefetchModel(_ prefetchModel:DataSourcePrefetchModel<D>?) -> Void{
        if let op = prefetchModel {
            if !prefetchModels.contains(op) {
                prefetchModels.add(op)
            }
        }
    }
    
    func removeAllOperation() -> Void {
        prefetchModels.removeAllObjects()
    }
    
    func runOperation(){
        if self.prefetchModels.count == 0 {
            return
        }
        let prefetchModels_ = self.prefetchModels.copy() as? NSArray
        prefetchModels_?.enumerateObjects({ (prefetchMode, index, pointer) in
            let innerOperation = prefetchMode as! DataSourcePrefetchModel<D>
            if let dataSourceHelper = innerOperation.dataSourceHelper,let indexPaths = innerOperation.indexPaths {
                for indexPath in indexPaths {
                    let node = dataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section)
                    ArgoKitUtils.asynCaculationBlock {
                        dataSourceHelper.rowHeight(node, maxWidth: innerOperation.width)
                    }
                }
            }
        })
        if let removesModel = prefetchModels_ as? [Any] {
            self.prefetchModels.removeObjects(in:removesModel)
        }
       
    }

    deinit {
        stopRunloop()
    }
}
