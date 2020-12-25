//
//  ArgoKitGridFlowLayout.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/17.
//

import Foundation
extension GridDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       columnCountFor section: Int) -> Int{
        if let layout =  collectionViewLayout as? GridFlowLayout{
            return layout.columnCount
        }
        return 1
    }
}
public protocol GridDelegateFlowLayout:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       columnCountFor section: Int) -> Int
}
public class GridFlowLayout:UICollectionViewFlowLayout{
    var itemHeight:CGFloat = 0
    
    var columnCount:Int = 1{
        didSet{
            invalidateLayout()
        }
    }
    
    var headerHeight:CGFloat = 0{
        didSet{
            invalidateLayout()
        }
    }
    
    var footerHeight:CGFloat = 0{
        didSet{
            invalidateLayout()
        }
    }
    
    var itemRenderDirection: ItemRenderDirection = .shortestFirst{
        didSet{
            invalidateLayout()
        }
    }
    
    var akSectionInsetReference: AKSectionInsetReference = .fromContentInset{
        didSet{
            invalidateLayout()
        }
    }
    
    var contentWidth: CGFloat = 0
    var frame:CGRect! = CGRect.zero{
        didSet{
            contentWidth = contentWidth_
        }
    }
    
    private var contentWidth_: CGFloat {
        let insets: UIEdgeInsets
        switch akSectionInsetReference {
        case .fromContentInset:
            insets = collectionView!.contentInset
        case .fromSafeArea:
            if #available(iOS 11.0, *) {
                insets = collectionView!.safeAreaInsets
            } else {
                insets = .zero
            }
        case .fromLayoutMargins:
            insets = collectionView!.layoutMargins
        }
        return frame.width - insets.left - insets.right
    }
    
    public func columnCount(forSection section: Int) -> Int {
//        if let delegate = collectionView?.delegate as? GridNode {
//            return delegate.collectionView(collectionView!, layout: self, columnCountFor: section)
//        }
        return columnCount
    }

    public func collectionViewContentWidth(ofSection section: Int) -> CGFloat {
//        if let delegate = collectionView?.delegate as? GridNode {
//            let insets = delegate.collectionView(collectionView!, layout: self, insetForSectionAt: section)
//            return contentWidth - insets.left - insets.right
//        }
        return contentWidth - sectionInset.left - sectionInset.right
    }
    
    public func itemWidth(inSection section: Int) -> CGFloat {
        let columnCount = self.columnCount(forSection: section)
        let spaceColumCount = CGFloat(columnCount - 1)
        let width = collectionViewContentWidth(ofSection: section)
        return floor((width - (spaceColumCount * minimumInteritemSpacing)) / CGFloat(columnCount))
    }
}

extension GridFlowLayout{
    
    public enum ItemRenderDirection: Int {
        case shortestFirst
        case leftToRight
        case rightToLeft
    }
    
    public enum AKSectionInsetReference:Int {
        
        case fromContentInset = 0
        @available(iOS 11, *)
        case fromSafeArea = 1

        case fromLayoutMargins = 2
    }
}

//MARK: item layout设置配置参数
extension Grid{
    @discardableResult
    public func itemHeight(_ value:CGFloat) -> Self{
        gridNode?.itemHeight(value)
        return self
    }
    
    public func headerHeight(_ value:CGFloat) -> Self {
        gridNode?.headerHeight(value)
        return self
    }
    
    public func footerHeight(_ value:CGFloat) -> Self {
        gridNode?.footerHeight(value)
        return self
    }
    
    @discardableResult
    public func columnCount(_ value:Int) -> Self {
        gridNode?.columnCount(value)
        return self
    }
    @discardableResult
    public func columCount(_ function:@escaping (_ section:Int)->Int) -> Self {
        let sel = #selector(gridNode?.collectionView(_:layout:columnCountFor:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 1,
               let count = paramter?.first as? Int{
               return function(count)
            }
            return nil
        })
        return self
    }
    @discardableResult
    public func columnSpacing(_ value:CGFloat) -> Self{
        gridNode?.columnSpacing(value)
        return self
    }
    @discardableResult
    public func columnSpacing(_ function:@escaping (_ section:Int)->CGFloat) -> Self {
        let sel = #selector(gridNode?.collectionView(_:layout:minimumInteritemSpacingForSectionAt:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 1,
               let count = paramter?.first as? Int{
               return function(count)
            }
            return nil
        })
        return self
    }
    @discardableResult
    public func lineSpacing(_ value:CGFloat) -> Self{
        gridNode?.lineSpacing(value)
        return self
    }
    @discardableResult
    public func lineSpacing(_ function:@escaping (_ section:Int)->CGFloat) -> Self {
        let sel = #selector(gridNode?.collectionView(_:layout:minimumLineSpacingForSectionAt:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 1,
               let count = paramter?.first as? Int{
               return function(count)
            }
            return nil
        })
        return self
    }
    
    @discardableResult
    public func layoutInset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        let value = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        gridNode?.sectionInset(value)
        return self
    }
    
    @discardableResult
    public func layoutInset(_ function:@escaping (_ section:Int)->UIEdgeInsets) -> Self {
        let sel = #selector(gridNode?.collectionView(_:layout:insetForSectionAt:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 1,
               let count = paramter?.first as? Int{
               return function(count)
            }
            return nil
        })
        return self
    }
    
    @discardableResult
    public func headersPinToVisibleBounds(_ value:Bool) -> Self {
        gridNode?.sectionHeadersPinToVisibleBounds(value)
        return self
    }
    
    @discardableResult
    public func scrollDirection(_ value:UICollectionView.ScrollDirection)->Self{
        gridNode?.scrollDirection(value)
        return self
    }
    
    @available(iOS 11.0, *)
    public func sectionInsetReference(_ value:UICollectionViewFlowLayout.SectionInsetReference) -> Self {
        gridNode?.sectionInsetReference(value)
        return self
    }
    
    @discardableResult
    public func itemRenderDirection(_ value :GridFlowLayout.ItemRenderDirection) ->Self {
        gridNode?.itemRenderDirection(value)
        return self
    }
}
