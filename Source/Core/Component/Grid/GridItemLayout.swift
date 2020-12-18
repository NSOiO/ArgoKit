//
//  GridItemLayout.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/18.
//

import Foundation
//MARK: item layout设置配置参数
extension Grid{
    @discardableResult
    public func itemHeight(_ value:CGFloat = 0) -> Self{
        gridNode?.itemHeight(value)
        return self
    }
    
    @discardableResult
    public func columnCount(_ value:Int = 1) -> Self{
        gridNode?.columnCount(value)
        return self
    }

    public func columnSpacing(_ value:CGFloat = 0) -> Self{
        gridNode?.columnSpacing(value)
        return self
        
    }
    
    public func lineSpacing(_ value:CGFloat = 0) -> Self{
        gridNode?.lineSpacing(value)
        return self
    }
    
    public func estimatedItemSize(_ value:CGSize = CGSize.zero) -> Self{
        gridNode?.estimatedItemSize(value)
        return self
    }
    
    public func scrollDirection(_ value:UICollectionView.ScrollDirection = .vertical)->Self{
        gridNode?.scrollDirection(value)
        return self
    }
    
    public func headerReferenceSize(_ value:CGSize = CGSize.zero) ->Self {
        gridNode?.headerReferenceSize(value)
        return self
    }
    
    public func footerReferenceSize(_ value:CGSize = CGSize.zero) ->Self {
        gridNode?.footerReferenceSize(value)
        return self
    }

    public func sectionInset(_ value:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )) -> Self {
        gridNode?.sectionInset(value)
        return self
    }
    
    @available(iOS 11.0, *)
    public func sectionInsetReference(_ value:UICollectionViewFlowLayout.SectionInsetReference = .fromContentInset) -> Self {
        gridNode?.sectionInsetReference(value)
        return self
    }
    
    public func sectionHeadersPinToVisibleBounds(_ value:Bool = false) -> Self {
        gridNode?.sectionHeadersPinToVisibleBounds(value)
        return self
    }
    
    public func sectionFootersPinToVisibleBounds(_ value:Bool = false) -> Self {
        gridNode?.sectionFootersPinToVisibleBounds(value)
        return self
    }
}
