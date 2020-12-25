//
//  PageControl.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/28.
//

import Foundation
class ArgoKitPageControlNode: ArgoKitNode {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return size
    }
}
public struct PageControl:View{
    private let pNode:ArgoKitPageControlNode
    public var node: ArgoKitNode?{
        pNode
    }
    public init(currentPage:Int,numberOfPages:Int,onPageChange:@escaping(_ currentPage:Int)->Void){
        pNode = ArgoKitPageControlNode(viewClass: UIPageControl.self)
        addAttribute(#selector(setter:UIPageControl.currentPage),currentPage)
        addAttribute(#selector(setter:UIPageControl.numberOfPages),numberOfPages)
        
        pNode.addAction({ (obj, paramter) -> Any? in
            if let pageControl = obj as? UIPageControl {
                onPageChange(pageControl.currentPage)
            }
            return nil
        }, for: UIControl.Event.valueChanged)
    }
}

extension PageControl{
    /// default is 0
    @discardableResult
    public func numberOfPages(_ value:Int)->Self{
        addAttribute(#selector(setter:UIPageControl.numberOfPages),value)
        return self
    }
    
    /// default is 0. Value is pinned to 0..numberOfPages-1
    
    @discardableResult
    public func currentPage(_ value:Int)->Self{
        addAttribute(#selector(setter:UIPageControl.currentPage),value)
        return self
    }
    
    /// hides the indicator if there is only one page, default is NO
    @discardableResult
    public func hidesForSinglePage(_ value:Bool)->Self{
        addAttribute(#selector(setter:UIPageControl.hidesForSinglePage),value)
        return self
    }
    
    /// The tint color for non-selected indicators. Default is nil.
    @available(iOS 6.0, *)
    @discardableResult
    public func pageIndicatorTintColor(_ value:UIColor?)->Self{
        addAttribute(#selector(setter:UIPageControl.pageIndicatorTintColor),value)
        return self
    }

    /// The tint color for the currently-selected indicators. Default is nil.
    @available(iOS 6.0, *)
    @discardableResult
    public func currentPageIndicatorTintColor(_ value:UIColor?)->Self{
        addAttribute(#selector(setter:UIPageControl.currentPageIndicatorTintColor),value)
        return self
    }

    /// The preferred background style. Default is UIPageControlBackgroundStyleAutomatic on iOS, and UIPageControlBackgroundStyleProminent on tvOS.
    @available(iOS 14.0, *)
    @discardableResult
    public func backgroundStyle(_ value:UIPageControl.BackgroundStyle)->Self{
        addAttribute(#selector(setter:UIPageControl.backgroundStyle),value)
        return self
    }
    
    /// The current interaction state for when the current page changes. Default is UIPageControlInteractionStateNone
    @available(iOS 14.0, *)
    @discardableResult
    public func interactionState()->UIPageControl.InteractionState{
        if let view = self.node?.view as? UIPageControl{
            return view.interactionState
        }
        return .none
    }
    /// Returns YES if the continuous interaction is enabled, NO otherwise. Default is YES.
    @available(iOS 14.0, *)
    @discardableResult
    public func allowsContinuousInteraction(_ value:Bool)->Self{
        addAttribute(#selector(setter:UIPageControl.allowsContinuousInteraction),value)
        return self
    }

    /// The preferred image for indicators. Symbol images are recommended. Default is nil.
    @available(iOS 14.0, *)
    @discardableResult
    public func preferredIndicatorImage(_ value:UIImage?)->Self{
        addAttribute(#selector(setter:UIPageControl.preferredIndicatorImage),value)
        return self
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
    
    /**
     * @abstract Override the indicator image for a specific page. Symbol images are recommended.
     * @param image    The image for the indicator. Resets to the default if image is nil.
     * @param page      Must be in the range of 0..numberOfPages
     */
    @available(iOS 14.0, *)
    @discardableResult
    public func setIndicatorImage(_ image: UIImage?, forPage page: Int)->Self{
        addAttribute(#selector(UIPageControl.setIndicatorImage),image,page)
        return self
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
   @available(*, unavailable, message: "PageControl does not support padding!")
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return self
    }
   @available(*, unavailable, message: "PageControl does not support padding!")
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        return self
    }
}
