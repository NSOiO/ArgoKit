//
//  ViewPage.Bind.swift
//  ArgoKit
//
//  Created by xindong on 2020/12/31.
//

import Foundation

extension ViewPage {
    @discardableResult
    public func scrollToPage(index:@escaping @autoclosure () -> Int) -> Self {
		return self.bindCallback({ [self] in 
			viewPageNode.scrollToPage(index: index())
		}, forKey: #function)
    }
    @discardableResult
    public func pageCount(pageCount:@escaping @autoclosure () -> Int) -> Self {
		return self.bindCallback({ [self] in 
			viewPageNode.pageCount(pageCount: pageCount())
		}, forKey: #function)
    }
    @discardableResult
    public func scrollEnable(enable:@escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter: UICollectionView.isScrollEnabled), enable())
		}, forKey: #function)
    }
    @discardableResult
    public func reuseEnable(enable:@escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			viewPageNode.reuseEnable(enable: enable())
		}, forKey: #function)
    }
    @discardableResult
    public func spacing(spacing:@escaping @autoclosure () -> CGFloat) -> Self {
		return self.bindCallback({ [self] in 
			viewPageNode.spacing(spacing: spacing())
		}, forKey: #function)
    }
}
