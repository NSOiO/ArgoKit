//
//  PageControl.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/28.
//

import Foundation
class ArgoKitPageControlNode: ArgoKitNode {
    var _currentPage:Int = 0
    var currentPage:Int{
        get{
            return _currentPage;
        }
        set{
            _currentPage = newValue
        }
    }
    var _totolsPage:Int = 0
    var totolsPage:Int{
        get{
            return _totolsPage;
        }
        set{
            _totolsPage = newValue
        }
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return size
    }
    
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let page = UIPageControl(frame: frame)
        page.defersCurrentPageDisplay = true
        page.updateCurrentPageDisplay()
        return page
    }
    
    override func reuseNodeToView(node: ArgoKitNode, view: UIView?) {
        super.reuseNodeToView(node: node, view: view)
        if let pageControl = view as? UIPageControl,let pageControlNode = node as? ArgoKitPageControlNode {
            pageControl.numberOfPages = pageControlNode.totolsPage
            pageControl.currentPage = pageControlNode.currentPage
            pageControl.defersCurrentPageDisplay = true
            pageControl.updateCurrentPageDisplay()
        }
    }
}
public struct PageControl:View{
    private let pNode:ArgoKitPageControlNode
    public var node: ArgoKitNode?{
        pNode
    }
    public init(currentPage: @escaping @autoclosure () -> Int, numberOfPages: @escaping @autoclosure () -> Int, onPageChange: @escaping(_ currentPage:Int) -> Void) {
        pNode = ArgoKitPageControlNode(viewClass: UIPageControl.self, type: Self.self)
        self.currentPage(currentPage())
        self.numberOfPages(numberOfPages())

        pNode.addAction({ (obj, paramter) -> Any? in
            if let pageControl = obj as? UIPageControl {
                onPageChange(pageControl.currentPage)
            }
            return nil
        }, for: UIControl.Event.valueChanged)
    }
}

extension PageControl{
    /// The current interaction state for when the current page changes. Default is UIPageControlInteractionStateNone
    @available(iOS 14.0, *)
    @discardableResult
    public func interactionState()->UIPageControl.InteractionState{
        if let view = self.node?.view as? UIPageControl{
            return view.interactionState
        }
        return .none
    }
    
    /**
     * @abstract Returns the override indicator image for the specific page, nil if no override image was set.
     * @param page Must be in the range of 0..numberOfPages
     */
    @available(iOS 14.0, *)
    public func indicatorImage(forPage page: Int)->UIImage?{
        if let view = self.node?.view as? UIPageControl{
            return view.indicatorImage(forPage: page)
        }
        return nil
    }
    
    /// Returns the minimum size required to display indicators for the given page count. Can be used to size the control if the page count could change.
    public func size(forNumberOfPages pageCount: Int) -> CGSize{
        if let view = self.node?.view as? UIPageControl{
            return view.size(forNumberOfPages: pageCount)
        }
        return CGSize.zero
    }
    
    /// if set, tapping to a new page won't update the currently displayed page until -updateCurrentPageDisplay is called. default is NO
    @available(iOS, introduced: 2.0, deprecated: 14.0, message: "defersCurrentPageDisplay no longer does anything reasonable with the new interaction mode.")
    public func defersCurrentPageDisplay(_ value: Bool) -> Self{
        addAttribute(#selector(setter:UIPageControl.defersCurrentPageDisplay),value)
        return self
    }

    /// update page display to match the currentPage. ignored if defersCurrentPageDisplay is NO. setting the page value directly will update immediately
    @available(iOS, introduced: 2.0, deprecated: 14.0, message: "updateCurrentPageDisplay no longer does anything reasonable with the new interaction mode.")
    @discardableResult
    public func updateCurrentPageDisplay()-> Self{
        addAttribute(#selector(UIPageControl.updateCurrentPageDisplay))
        return self
    }
}


extension PageControl{
   @available(*, deprecated, message: "PageControl does not support padding!")
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return self
    }
   @available(*, deprecated, message: "PageControl does not support padding!")
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        return self
    }
}
