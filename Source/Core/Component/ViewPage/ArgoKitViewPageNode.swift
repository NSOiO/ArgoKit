//
//  ArgoKitViewPagerNode.swift
//  ArgoKit
//
//  Created by sun-zt on 2020/12/4.
//

import Foundation

fileprivate let kCellReuseIdentifier = "ArgoKitViewPageCell"

public typealias ViewPageChangedCloser = (_ item:Any?, _ index:Int) -> Void
public typealias ViewPageTabScrollingListener = (_ percent:CGFloat, _ fromIndex:Int, _ toIndex:Int) -> Void

// MARK: Init

class ArgoKitViewPage: UICollectionView {
    private var oldFrame = CGRect.zero
    public override func layoutSubviews() {
        if !oldFrame.equalTo(self.frame) {
            ArgoKitReusedLayoutHelper.forLayoutNode(ArgoKitCellNode.self,frame: self.bounds)
            oldFrame = self.frame
        }
        super.layoutSubviews()
    }
}

class ArgoKitViewPageNode: ArgoKitScrollViewNode, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    public var viewPage:UICollectionView {
        self.view as! UICollectionView
    }
    
    private lazy var viewPageLayout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy var dataSourceHelper = ArgoKitDataSourceHelper()
    
    private var isReuseEnable:Bool = true
    
    private var pageCount:Int = 0
    
    private var currentIndex:Int = 0
    
    private var itemSpacing:CGFloat = 0.0
    
    private var isScrolling:Bool = false
    
    private var pageChangedFunc:ViewPageChangedCloser?
    private var pageTabScrollingListener:ViewPageTabScrollingListener?
    
    
}

// MARK: Node

extension ArgoKitViewPageNode {
    
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let collectionView = ArgoKitViewPage(frame: frame, collectionViewLayout: viewPageLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bouncesZoom = false
        
        if self.currentIndex > 0 {
            collectionView.scrollToItem(at: NSIndexPath(item: self.currentIndex, section: 0) as IndexPath, at: .centeredHorizontally, animated: false)
        }
        
        return collectionView
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize.zero
    }
}

// MARK: public method

extension ArgoKitViewPageNode {
    
    public func reloadData() {
        self.viewPage.reloadData()
    }
    
    public func pageCount(pageCount:Int) {
        self.pageCount = pageCount
    }
    
    public func scrollToPage(index:Int) {
        self.currentIndex = index
        
        if (self.view != nil) {
            self.viewPage.scrollToItem(at: NSIndexPath(item: index, section: 0) as IndexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    public func spacing(spacing:CGFloat) {
        self.itemSpacing = spacing
    }
    
    public func reuseEnable(enable:Bool) {
        self.isReuseEnable = enable
    }
    
    public func onChangeSelected(selectedFunc:@escaping ViewPageChangedCloser) {
        self.pageChangedFunc = selectedFunc
    }
    
    public func setTabScrollingListener(scrollListener:@escaping ViewPageTabScrollingListener) {
        self.pageTabScrollingListener = scrollListener
    }
    
}

// MARK: UICollectionViewDataSource

extension ArgoKitViewPageNode {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.dataSourceHelper.numberOfRows(section: section)
        if count > self.pageCount {
            return count
        }
        return self.pageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var identifier = self.dataSourceHelper.reuseIdForRow(indexPath.row, at: indexPath.section) ?? kCellReuseIdentifier
        if !self.isReuseEnable {
            identifier = identifier + String(indexPath.row)
        }
        if !self.dataSourceHelper.registedReuseIdSet.contains(identifier) {
            viewPage.register(ArgoKitViewPageCell.self, forCellWithReuseIdentifier: identifier)
            self.dataSourceHelper.registedReuseIdSet.insert(identifier)
        }
        let cell = viewPage.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ArgoKitViewPageCell
        if let node = self.dataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section) {
            cell.linkCellNode(node)
        }
        return cell
    }
    
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension ArgoKitViewPageNode {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - self.itemSpacing;
//        return CGSize(width: width, height: self.dataSourceHelper.rowHeight(indexPath.row, at: indexPath.section, maxWidth: width))
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: self.itemSpacing / 2.0, bottom: 0, right:  self.itemSpacing / 2.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.itemSpacing
    }
    
}

// MARK: Scroll
extension ArgoKitViewPageNode {
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        super.scrollViewWillBeginDragging(scrollView)
        self.isScrolling = true
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        super.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        self.isScrolling = decelerate
        scrollViewScrollEnd(scrollView)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        super.scrollViewDidEndDecelerating(scrollView)
        self.isScrolling = false
        scrollViewScrollEnd(scrollView)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewScrollPercent(scrollView)
    }
    
    func scrollViewScrollPercent(_ scrollView: UIScrollView) {
        guard self.isScrolling else { return }
        guard let listener = self.pageTabScrollingListener else { return }
        
        let percentX = scrollView.contentOffset.x / scrollView.frame.width
        let toIndex:Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        listener(percentX, self.currentIndex, toIndex)
    }
    
    func scrollViewScrollEnd(_ scrollView: UIScrollView) {
        guard !self.isScrolling else { return }
        
        let toIndex:Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
        let fromIndex = self.currentIndex
        self.currentIndex = toIndex
        
        if let changedFunc = self.pageChangedFunc {
            let count = self.dataSourceHelper.numberOfRows(section: 0)
            var item:Any? = nil
            if count > toIndex {
                item = self.dataSourceHelper.dataList?[0][toIndex]
            }
            changedFunc(item, toIndex)
        }
        
        if let listener = self.pageTabScrollingListener {
            let percentX = scrollView.contentOffset.x / scrollView.frame.width
            listener(percentX, fromIndex, toIndex)
        }
    }
}
