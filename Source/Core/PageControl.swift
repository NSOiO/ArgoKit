//
//  PageControl.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/28.
//

import Foundation
public struct PageControl:View{
    public var body: View{
        self
    }
    private let pPageControl:UIPageControl
    private let pNode:ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
    }
    public var type: ArgoKitNodeType{
        .single(pNode)
    }
    public init(currentPage:Int,numberOfPages:Int,onPageChange:@escaping(_ currentPage:Int)->Void){
        pPageControl = UIPageControl()
        pPageControl.currentPage = currentPage
        pPageControl.numberOfPages = numberOfPages
        pNode = ArgoKitNode(view: pPageControl)
        
        pNode.addTarget(pPageControl, for: UIControl.Event.valueChanged) { (obj, paramter) in
            if let pageControl = obj as? UIPageControl {
                onPageChange(pageControl.currentPage)
            }
            return nil
        }
    }
}

extension PageControl{
    /// default is 0
    public func numberOfPages(_ value:Int)->Self{
        pPageControl.numberOfPages = value
        return self
    }
    
    /// default is 0. Value is pinned to 0..numberOfPages-1
    public func currentPage(_ value:Int)->Self{
        pPageControl.currentPage = value
        return self
    }
    
    /// hides the indicator if there is only one page, default is NO
    public func hidesForSinglePage(_ value:Bool)->Self{
        pPageControl.hidesForSinglePage = value
        return self
    }
    
    /// The tint color for non-selected indicators. Default is nil.
    @available(iOS 6.0, *)
    public func pageIndicatorTintColor(_ value:UIColor?)->Self{
        pPageControl.pageIndicatorTintColor = value
        return self
    }

    /// The tint color for the currently-selected indicators. Default is nil.
    @available(iOS 6.0, *)
    public func currentPageIndicatorTintColor(_ value:UIColor?)->Self{
        pPageControl.currentPageIndicatorTintColor = value
        return self
    }

    /// The preferred background style. Default is UIPageControlBackgroundStyleAutomatic on iOS, and UIPageControlBackgroundStyleProminent on tvOS.
    @available(iOS 14.0, *)
    public func backgroundStyle(_ value:UIPageControl.BackgroundStyle)->Self{
        pPageControl.backgroundStyle = value
        return self
    }
    
    /// The current interaction state for when the current page changes. Default is UIPageControlInteractionStateNone
    @available(iOS 14.0, *)
    public func interactionState()->UIPageControl.InteractionState{
        return  pPageControl.interactionState
    }
    /// Returns YES if the continuous interaction is enabled, NO otherwise. Default is YES.
    @available(iOS 14.0, *)
    public func allowsContinuousInteraction(_ value:Bool)->Self{
        pPageControl.allowsContinuousInteraction = value
        return self
    }

    /// The preferred image for indicators. Symbol images are recommended. Default is nil.
    @available(iOS 14.0, *)
    public func preferredIndicatorImage(_ value:UIImage?)->Self{
        pPageControl.preferredIndicatorImage = value
        return self
    }
    
    /**
     * @abstract Returns the override indicator image for the specific page, nil if no override image was set.
     * @param page Must be in the range of 0..numberOfPages
     */
    @available(iOS 14.0, *)
    public func indicatorImage(forPage page: Int)->UIImage?{
        return pPageControl.indicatorImage(forPage: page)
    }
    
    /**
     * @abstract Override the indicator image for a specific page. Symbol images are recommended.
     * @param image    The image for the indicator. Resets to the default if image is nil.
     * @param page      Must be in the range of 0..numberOfPages
     */
    @available(iOS 14.0, *)
    public func setIndicatorImage(_ image: UIImage?, forPage page: Int)->Self{
        pPageControl.setIndicatorImage(image,forPage:page)
        return self
    }
    
    /// Returns the minimum size required to display indicators for the given page count. Can be used to size the control if the page count could change.
    public func size(forNumberOfPages pageCount: Int) -> CGSize{
        return pPageControl.size(forNumberOfPages: pageCount)
    }
    
    /// if set, tapping to a new page won't update the currently displayed page until -updateCurrentPageDisplay is called. default is NO
    @available(iOS, introduced: 2.0, deprecated: 14.0, message: "defersCurrentPageDisplay no longer does anything reasonable with the new interaction mode.")
    public func defersCurrentPageDisplay(_ value: Bool) -> Self{
        pPageControl.defersCurrentPageDisplay = value
        return self
    }

    /// update page display to match the currentPage. ignored if defersCurrentPageDisplay is NO. setting the page value directly will update immediately
    @available(iOS, introduced: 2.0, deprecated: 14.0, message: "updateCurrentPageDisplay no longer does anything reasonable with the new interaction mode.")
    public func updateCurrentPageDisplay()-> Self{
        pPageControl.updateCurrentPageDisplay()
        return self
    }
}
