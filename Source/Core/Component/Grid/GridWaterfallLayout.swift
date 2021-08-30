//
//  GridWaterfallLayout.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/21.
//

import Foundation

import UIKit

private func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

private func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

public extension GridDelegateWaterfallLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        if let layout =  collectionViewLayout as? GridWaterfallLayout{
            return CGSize(width:collectionView.frame.size.width,height:layout.headerHeight)
        }
        return  CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize{
        if let layout =  collectionViewLayout as? GridWaterfallLayout{
            return CGSize(width:collectionView.frame.size.width,height:layout.footerHeight)
        }
        return  CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         insetForSectionAt section: Int) -> UIEdgeInsets{
         if let layout =  collectionViewLayout as? GridWaterfallLayout{
             return layout.sectionInset
         }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
     }

    func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        if let layout =  collectionViewLayout as? GridWaterfallLayout{
            return layout.minimumInteritemSpacing
        }
        return  0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        if let layout =  collectionViewLayout as? GridWaterfallLayout{
            return layout.minimumLineSpacing
        }
        return  0
    }

    func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       columnCountFor section: Int) -> Int{
        if let layout =  collectionViewLayout as? GridWaterfallLayout{
            return layout.columnCount
        }
        return 1
    }
}
public protocol GridDelegateWaterfallLayout: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize;

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize

    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets

    
    func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat

    
    func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       columnCountFor section: Int) -> Int
}

public class GridWaterfallLayout: GridFlowLayout {

    public var delegate: GridDelegateWaterfallLayout? {
        get {
            return collectionView!.delegate as? GridDelegateWaterfallLayout
        }
    }
    
    private var ignorPrepare:Bool = false

    private var columnHeights: [[CGFloat]] = []
    private var sectionItemAttributes: [[UICollectionViewLayoutAttributes]] = []
    private var allItemAttributes: [UICollectionViewLayoutAttributes] = []
    private var headersAttributes: [Int: UICollectionViewLayoutAttributes] = [:]
    private var footersAttributes: [Int: UICollectionViewLayoutAttributes] = [:]
    private var unionRects: [CGRect] = []
    private let unionSize = 20


    override public func prepare() {
        super.prepare()
        if ignorPrepare {
            ignorPrepare = false
            return
        }
        let numberOfSections = collectionView!.numberOfSections
        if numberOfSections == 0 {
            return
        }
        headersAttributes = [:]
        footersAttributes = [:]
        unionRects = []
        allItemAttributes = []
        sectionItemAttributes = []
        columnHeights = (0 ..< numberOfSections).map { section in
            let columnCount = self.columnCount(forSection: section)
            let sectionColumnHeights = (0 ..< columnCount).map { CGFloat($0) }
            return sectionColumnHeights
        }

        var top: CGFloat = 0.0
        var attributes = UICollectionViewLayoutAttributes()

        for section in 0 ..< numberOfSections {
            // 获取行间距
            let lineSpacing = delegate?.collectionView(collectionView!, layout: self, minimumLineSpacingForSectionAt: section)
                ?? self.minimumLineSpacing
            // 获取Insets值
            let sectionInsets = delegate?.collectionView(collectionView!, layout: self, insetForSectionAt: section) ?? self.sectionInset
            // 获取section中item的数量
            let columnCount = columnHeights[section].count
            // 计算每个item的宽度
            var itemWidth = self.itemWidth(inSection: section)

            // MARK: 2. Section header
            var headerSize = CGSize(width:collectionView!.frame.size.width,height: self.headerHeight)
            if let size = delegate?.collectionView(collectionView!,layout:self,referenceSizeForHeaderInSection:section){
                headerSize = size
            }
            if headerSize.height > 0 {
                attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(row: 0, section: section))
                attributes.frame = CGRect(x: 0, y: top, width: headerSize.width, height: headerSize.height)
                headersAttributes[section] = attributes
                allItemAttributes.append(attributes)

                top = attributes.frame.maxY
            }
            top += sectionInsets.top
            columnHeights[section] = [CGFloat](repeating: top, count: columnCount)

            // MARK: 3. Section items
            let itemCount = collectionView!.numberOfItems(inSection: section)
            var itemAttributes: [UICollectionViewLayoutAttributes] = []
            var itemAttributes_: [UICollectionViewLayoutAttributes] = []
            // Item will be put into shortest column.
            for idx in 0 ..< itemCount {
                
                let interitemSpacing = delegate?.collectionView(collectionView!, layout: self, minimumInteritemSpacingForSectionAt: section)
                    ?? self.minimumLineSpacing
                let indexPath = IndexPath(item: idx, section: section)
                
                let size = delegate?.collectionView(collectionView!, layout: self, sizeForItemAt: indexPath)
                if size?.width > 0  {
                    itemWidth = size?.width ?? itemWidth
                }
                let columnIndex = nextColumnIndexForItem(idx, inSection: section)
                var preItemWith:CGFloat = 0
                if columnIndex == 0 {
                    preItemWith = itemWidth
                    itemAttributes_.removeAll()
                }else{
                    if allItemAttributes.count > 0 {
                        let attributes_ = itemAttributes_[columnIndex - 1]
                        preItemWith = attributes_.frame.width
                    }
                }

                
                let xOffset = sectionInsets.left + (preItemWith + interitemSpacing) * CGFloat(columnIndex)

                let yOffset = columnHeights[section][columnIndex]
                var itemHeight: CGFloat = 0.0
                if let itemSize = size,
                    itemSize.height > 0 {
                    itemHeight = itemSize.height
                    if itemSize.width > 0 {
                        itemHeight = floor(itemHeight * itemWidth / itemSize.width)
                    }
                }

                attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
                itemAttributes.append(attributes)
                itemAttributes_.append(attributes)
                allItemAttributes.append(attributes)
                columnHeights[section][columnIndex] = attributes.frame.maxY + lineSpacing
            }
            sectionItemAttributes.append(itemAttributes)

            // MARK: 4. Section footer
            let columnIndex  = longestColumnIndex(inSection: section)
            top = columnHeights[section][columnIndex] - lineSpacing + sectionInsets.bottom
 
            var sizeFooter = CGSize(width:collectionView!.frame.size.width,height: self.footerHeight)
            if let size = delegate?.collectionView(collectionView!,layout:self,referenceSizeForFooterInSection:section){
                sizeFooter = size
            }

            if sizeFooter.height > 0 {
                attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: 0, y: top, width: sizeFooter.width, height: sizeFooter.height)
                footersAttributes[section] = attributes
                allItemAttributes.append(attributes)
                top = attributes.frame.maxY
            }

            columnHeights[section] = [CGFloat](repeating: top, count: columnCount)
        }

        var idx = 0
        let itemCounts = allItemAttributes.count
        while idx < itemCounts {
            let rect1 = allItemAttributes[idx].frame
            idx = min(idx + unionSize, itemCounts) - 1
            let rect2 = allItemAttributes[idx].frame
            unionRects.append(rect1.union(rect2))
            idx += 1
        }
    }

    override public var collectionViewContentSize: CGSize {
        if collectionView!.numberOfSections == 0 {
            return .zero
        }

        var contentSize = collectionView!.bounds.size
        contentSize.width = contentWidth

        if let height = columnHeights.last?.first {
            contentSize.height = height
            return contentSize
        }
        return .zero
    }

    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.section >= sectionItemAttributes.count {
            return nil
        }
        let list = sectionItemAttributes[indexPath.section]
        if indexPath.item >= list.count {
            return nil
        }
        return list[indexPath.item]
    }

    override public func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        var attribute: UICollectionViewLayoutAttributes?
        if elementKind == UICollectionView.elementKindSectionHeader {
            attribute = headersAttributes[indexPath.section]
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            attribute = footersAttributes[indexPath.section]
        }
        return attribute ?? UICollectionViewLayoutAttributes()
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var begin = 0, end = unionRects.count
        if let i = unionRects.firstIndex(where: { rect.intersects($0) }) {
            begin = i * unionSize
        }
        if let i = unionRects.lastIndex(where: { rect.intersects($0) }) {
            end = min((i + 1) * unionSize, allItemAttributes.count)
        }
        
        if self.sectionHeadersPinToVisibleBounds {
           stickyHeader()
        }
        return self.allItemAttributes[begin..<end]
            .filter { rect.intersects($0.frame) }
    }
    private func stickyHeader(){
        for attr:UICollectionViewLayoutAttributes in self.allItemAttributes {
            if attr.representedElementKind == UICollectionView.elementKindSectionHeader {
                let section = attr.indexPath.section
                
                let numberOfItemsInSection = self.collectionView!.numberOfItems(inSection: section)
                let firstCellIndexPath = IndexPath(item:0,section:section)
                let item = Int(Float.maximum(0, Float(numberOfItemsInSection - 1)))
                let lastCellIndexPath = IndexPath(item:item,section:section)
                
                var firstCellAttributes = self.layoutAttributesForItem(at: firstCellIndexPath)
                var lastCellAttributes = self.layoutAttributesForItem(at: lastCellIndexPath)
                if let first =  self.layoutAttributesForItem(at: firstCellIndexPath),
                   let last = self.layoutAttributesForItem(at: lastCellIndexPath){
                    firstCellAttributes = first
                    lastCellAttributes = last
                }else{
                    firstCellAttributes = UICollectionViewLayoutAttributes()
                    let y = attr.frame.maxY + self.sectionInset.top;
                    firstCellAttributes?.frame = CGRect(x: 0, y: y, width: 0, height: 0);
                    lastCellAttributes = firstCellAttributes;
                }

                let headerHeight = attr.frame.height
                var frame = attr.frame
                let offset = self.collectionView?.contentOffset.y ?? 0
                let sectionInset = delegate?.collectionView(collectionView!, layout: self, insetForSectionAt: section) ?? self.sectionInset
                let headerY = (firstCellAttributes?.frame.minY)!-headerHeight - sectionInset.top
                let maxY = CGFloat.maximum(offset,headerY)
                
                let headerMissingY = (lastCellAttributes?.frame.maxY)! - headerHeight + sectionInset.bottom

                frame.origin.y = CGFloat.minimum(maxY, headerMissingY)

                attr.frame = frame
                attr.zIndex = 1024
            }
        }
    }

    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if self.sectionHeadersPinToVisibleBounds {
            invalidateLayout()
            ignorPrepare = true
            return false
        }
        return newBounds.width != collectionView?.bounds.width
    }

    /// Find the shortest column.
    ///
    /// - Returns: index for the shortest column
    private func shortestColumnIndex(inSection section: Int) -> Int {
        return columnHeights[section].enumerated()
            .min(by: { $0.element < $1.element })?
            .offset ?? 0
    }

    /// Find the longest column.
    ///
    /// - Returns: index for the longest column
    private func longestColumnIndex(inSection section: Int) -> Int {
        return columnHeights[section].enumerated()
            .max(by: { $0.element < $1.element })?
            .offset ?? 0
    }

    /// Find the index for the next column.
    ///
    /// - Returns: index for the next column
    private func nextColumnIndexForItem(_ item: Int, inSection section: Int) -> Int {
        var index = 0
        let columnCount = self.columnCount(forSection: section)
        switch itemRenderDirection {
        case .shortestFirst :
            index = shortestColumnIndex(inSection: section)
        case .leftToRight :
            index = item % columnCount
        case .rightToLeft:
            index = (columnCount - 1) - (item % columnCount)
        }
        return index
    }
}
