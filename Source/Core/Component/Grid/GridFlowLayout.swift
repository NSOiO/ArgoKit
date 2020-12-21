//
//  ArgoKitGridFlowLayout.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/17.
//

import Foundation
class GridFlowLayout: UICollectionViewFlowLayout {
    var columCount:Int = 1
    var width:CGFloat = 0
    var itemHeight:CGFloat = 0
    var headerHeiht:CGFloat = 0
    var footerHeiht:CGFloat = 0
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var frame:CGRect! = CGRect.zero{
        didSet{
            let width_ = frame.size.width
            let columSpace = minimumInteritemSpacing * CGFloat((columCount - 1))
            width = (width_ - columSpace - sectionInset.left - sectionInset.right) / CGFloat(columCount)
            width = floor(width)
            if itemHeight == 0 {
                itemSize = CGSize(width: width, height: itemHeight)
            }else{
                itemSize = CGSize(width: width, height: width)
            }
        }
    }
}


//MARK: item layout设置配置参数
extension Grid{
    @discardableResult
    public func itemHeight(_ value:CGFloat) -> Self{
        gridNode?.itemHeight(value)
        return self
    }
    
    @discardableResult
    public func columnCount(_ value:Int) -> Self{
        gridNode?.columnCount(value)
        return self
    }

    public func columnSpacing(_ value:CGFloat) -> Self{
        gridNode?.columnSpacing(value)
        return self
        
    }
    
    public func lineSpacing(_ value:CGFloat) -> Self{
        gridNode?.lineSpacing(value)
        return self
    }
    
    public func estimatedItemSize(_ value:CGSize) -> Self{
        gridNode?.estimatedItemSize(value)
        return self
    }
    
    public func scrollDirection(_ value:UICollectionView.ScrollDirection)->Self{
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

    public func layoutInset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        let value = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        gridNode?.sectionInset(value)
        return self
    }
    
    @available(iOS 11.0, *)
    public func sectionInsetReference(_ value:UICollectionViewFlowLayout.SectionInsetReference) -> Self {
        gridNode?.sectionInsetReference(value)
        return self
    }
    
    public func sectionHeadersPinToVisibleBounds(_ value:Bool) -> Self {
        gridNode?.sectionHeadersPinToVisibleBounds(value)
        return self
    }
    
    public func sectionFootersPinToVisibleBounds(_ value:Bool) -> Self {
        gridNode?.sectionFootersPinToVisibleBounds(value)
        return self
    }
}
