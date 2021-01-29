//
//  ArgoKitViewReaderHelper.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/18.
//

import Foundation

class ArgoKitViewReaderHelper{
    static var shared: ArgoKitViewReaderHelper = {
        let instance = ArgoKitViewReaderHelper()
        instance.startRunloop()
        return instance
    }()
    private init() {}
    
    var observe:CFRunLoopObserver?
    var operations:NSHashTable = NSHashTable<AnyObject>.weakObjects()
    func startRunloop() -> Void {
        let runloop:CFRunLoop = CFRunLoopGetMain()
        observe = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.beforeWaiting.rawValue, true, 1, {[weak self] (observer, activity) in
            self?.runOperation()
        })
        if let _ =  observe {
            CFRunLoopAddObserver(runloop, observe, CFRunLoopMode.commonModes)
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
    
    func addRenderOperation(operation:ArgoKitViewReaderOperation?) -> Void{
        if let op = operation {
            if !operations.contains(op) {
                operations.add(op)
            }
        }
    }
    
    func removeAllOperation() -> Void {
        operations.removeAllObjects()
    }
    
    func runOperation(){
        if self.operations.count == 0 {
            return
        }
        let operations = self.operations.copy() as! NSHashTable<AnyObject>
        for operation in operations.allObjects {
            let innerOperation = operation as! ArgoKitViewReaderOperation
            if innerOperation.needRemake {
                innerOperation.remakeIfNeed()
            }
        }
    }

    deinit {
        stopRunloop() 
    }
}
