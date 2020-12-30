//
//  PageControl.Bind.swift
//  ArgoKit
//
//  Created by xindong on 2020/12/30.
//

import Foundation

extension PageControl {
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
}
