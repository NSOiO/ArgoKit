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
    public func numberOfPages(_ value:@escaping @autoclosure () -> Int)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIPageControl.numberOfPages),value())
		}, forKey: #function)
    }
    
    /// default is 0. Value is pinned to 0..numberOfPages-1
    @discardableResult
    public func currentPage(_ value:@escaping @autoclosure () -> Int)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIPageControl.currentPage),value())
		}, forKey: #function)
    }
    
    /// hides the indicator if there is only one page, default is NO
    @discardableResult
    public func hidesForSinglePage(_ value:@escaping @autoclosure () -> Bool)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIPageControl.hidesForSinglePage),value())
		}, forKey: #function)
    }
    
    /// The tint color for non-selected indicators. Default is nil.
    @available(iOS 6.0, *)
    @discardableResult
    public func pageIndicatorTintColor(_ value:@escaping @autoclosure () -> UIColor?)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIPageControl.pageIndicatorTintColor),value())
		}, forKey: #function)
    }

    /// The tint color for the currently-selected indicators. Default is nil.
    @available(iOS 6.0, *)
    @discardableResult
    public func currentPageIndicatorTintColor(_ value:@escaping @autoclosure () -> UIColor?)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIPageControl.currentPageIndicatorTintColor),value())
		}, forKey: #function)
    }

    /// The preferred background style. Default is UIPageControlBackgroundStyleAutomatic on iOS, and UIPageControlBackgroundStyleProminent on tvOS.
    @available(iOS 14.0, *)
    @discardableResult
    public func backgroundStyle(_ value:@escaping @autoclosure () -> UIPageControl.BackgroundStyle)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIPageControl.backgroundStyle),value())
		}, forKey: #function)
    }
    
    /// Returns YES if the continuous interaction is enabled, NO otherwise. Default is YES.
    @available(iOS 14.0, *)
    @discardableResult
    public func allowsContinuousInteraction(_ value:@escaping @autoclosure () -> Bool)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIPageControl.allowsContinuousInteraction),value())
		}, forKey: #function)
    }

    /// The preferred image for indicators. Symbol images are recommended. Default is nil.
    @available(iOS 14.0, *)
    @discardableResult
    public func preferredIndicatorImage(_ value:@escaping @autoclosure () -> UIImage?)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIPageControl.preferredIndicatorImage),value())
		}, forKey: #function)
    }
    
    /**
     * @abstract Override the indicator image for a specific page. Symbol images are recommended.
     * @param image    The image for the indicator. Resets to the default if image is nil.
     * @param page      Must be in the range of 0..numberOfPages
     */
    @available(iOS 14.0, *)
    @discardableResult
    public func setIndicatorImage(_ image: @escaping @autoclosure () -> UIImage?, forPage page: @escaping @autoclosure () -> Int)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(UIPageControl.setIndicatorImage),image(),page())
		}, forKey: #function)
    }
}
