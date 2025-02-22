//
//  ArgoKitViewPagerNode.swift
//  ArgoKit
//
//  Created by sun-zt on 2020/12/4.
//

import Foundation

fileprivate let kCellReuseIdentifier = "ArgoKitViewPageCell"

public typealias ViewPageChangedCloser = (_ item:Any?, _ to:Int, _ from:Int) -> Void
public typealias ViewPageTabScrollingListener = (_ percent:CGFloat, _ fromIndex:Int, _ toIndex:Int, _ isScrolling:Bool) -> Void

// MARK: Init

class ArgoKitViewPage: UICollectionView {
    private var oldFrame = CGRect.zero
    var reLayoutAction:((CGRect)->())?
    public override func layoutSubviews() {
        if !oldFrame.equalTo(self.frame) {
            if let action = reLayoutAction {
                action(self.bounds)
            }
            oldFrame = self.frame
        }
        super.layoutSubviews()
    }
}

private struct ArgoKitViewPageScrollInfo {
    var isScroll = false
    var from = 0
    var to = 0
}

class ArgoKitViewPageNode<D>: ArgoKitScrollViewNode, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
    
    lazy var dataSourceHelper = DataSourceHelper<D>()
    
    private var isReuseEnable:Bool = true
    
    private var pageCount:Int = 0
    
    private var currentIndex:Int = 0
    
    private var itemSpacing:CGFloat = 0.0
    
    private var isScrolling:Bool = false
    
    private var pageChangedFunc:ViewPageChangedCloser?
    
    private var pageScrollInfo: ArgoKitViewPageScrollInfo?
    
    private var innerScrollListener: ViewPageTabScrollingListener?
    private var externalScrollListener: ViewPageTabScrollingListener?
    private var hasScrollListener: Bool {(innerScrollListener != nil) || (externalScrollListener != nil)}
    
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let collectionView = ArgoKitViewPage(frame: frame, collectionViewLayout: viewPageLayout)
        collectionView.reLayoutAction = { [weak self] frame in
            if let `self` = self {
                var cellNodes:[Any] = []
                cellNodes.append(contentsOf: self.dataSourceHelper.cellNodeCache)
                ArgoKitReusedLayoutHelper.reLayoutNode(cellNodes, frame: frame)
            }
        }
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


// MARK: UICollectionViewDataSource

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.dataSourceHelper.numberOfRows(section: section)
        if count > 0 {
            return count
        }
        return self.pageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let node = self.dataSourceHelper.nodeForRow(indexPath.item, at: indexPath.section)
        
        var identifier = self.dataSourceHelper.reuseIdForRow(indexPath.item, at: indexPath.section) ?? kCellReuseIdentifier
        if !self.isReuseEnable && node != nil {
            identifier = String(node!.hashValue)
        }
        
        if !self.dataSourceHelper.registedReuseIdSet.contains(identifier) {
            viewPage.register(ArgoKitViewPageCell.self, forCellWithReuseIdentifier: identifier)
            self.dataSourceHelper.registedReuseIdSet.insert(identifier)
        }
        let cell = viewPage.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ArgoKitViewPageCell
        cell.reuseEnable = self.isReuseEnable
        if node != nil {
            cell.linkCellNode(node!)
        }
        return cell
    }
    
    
// MARK: UICollectionViewDelegateFlowLayout
    
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
    
    
//// MARK: Scroll
    
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
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        super.scrollViewDidEndScrollingAnimation(scrollView)
        autoScrollEnd(scrollView)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        scrollViewScrollPercent(scrollView)
        autoScrollPercent(scrollView, true)
    }
    
    func scrollViewScrollPercent(_ scrollView: UIScrollView) {
        guard self.isScrolling else { return }
        guard hasScrollListener else { return }
        
        let offsetX = scrollView.contentOffset.x
        if offsetX < 0
            || (scrollView.contentSize.width - offsetX) < pageWidth() {
            return
        }
        
        let originX = pageWidth() * CGFloat(self.currentIndex)
        if abs(originX - offsetX) > pageWidth() {
            var offset = CGPoint(x: 0, y: scrollView.contentOffset.y)
            if offsetX > originX {
                offset.x = pageWidth() * CGFloat(self.currentIndex + 1)
            }else {
                offset.x = pageWidth() * CGFloat(self.currentIndex - 1)
            }
            scrollView.contentOffset = offset
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
            return
        }
        
        let toIndex:Int = calculateToIndex(scrollView)
        calculateScrollPercent(scrollView, from: self.currentIndex, to: toIndex, isScroll: true)
    }
    
    func scrollViewScrollEnd(_ scrollView: UIScrollView) {
        guard !self.isScrolling else { return }
        
        let toIndex:Int = calculateToIndex(scrollView)
        let fromIndex = self.currentIndex
        self.currentIndex = toIndex
        
        if let changedFunc = self.pageChangedFunc {
            let count = self.dataSourceHelper.numberOfRows(section: 0)
            var item:Any? = nil
            if count > toIndex && toIndex >= 0 {
                item = self.dataSourceHelper.dataForRow(toIndex, at: 0);
            }
            changedFunc(item, toIndex, fromIndex)
        }
        
        if hasScrollListener {
            calculateScrollPercent(scrollView, from: fromIndex, to: toIndex, isScroll: false)
        }
    }
    
    private func calculateToIndex(_ scrollView: UIScrollView) -> Int {
        let originX = pageWidth() * CGFloat(self.currentIndex)
        let offsetX = scrollView.contentOffset.x
        if offsetX <= 0 {
            return 0
        }
        if (scrollView.contentSize.width - offsetX) < pageWidth() {
            return self.currentIndex
        }
        
        if offsetX > originX {
            return self.currentIndex + 1
        }
        if offsetX < originX {
            return self.currentIndex - 1
        }
        return self.currentIndex
    }
    
    private func calculateScrollPercent(_ scrollView: UIScrollView, from:Int, to: Int, isScroll:Bool) {
        let offsetX = scrollView.contentOffset.x
        var percentX = offsetX / pageWidth()
        if (to > from) {
            percentX -= CGFloat(from)
        }else {
            percentX = abs(CGFloat(from) - percentX)
        }
        if let listener = innerScrollListener {
            listener(percentX, from, to, isScroll)
        }
        if let listener = externalScrollListener {
            listener(percentX, from, to, isScroll)
        }
    }
    
    private func pageWidth() -> CGFloat {
        return self.viewPage.frame.width
    }
    
    private func autoScrollPercent(_ scrollView: UIScrollView,_ isScroll: Bool) {
        guard let info = self.pageScrollInfo else { return }
        guard hasScrollListener else { return }
        let percent = (scrollView.contentOffset.x - CGFloat(info.from) * pageWidth()) / (CGFloat(info.to - info.from) * pageWidth())
        if let listener = innerScrollListener {
            listener(abs(percent), info.from, info.to, isScroll)
        }
        if let listener = externalScrollListener {
            listener(abs(percent), info.from, info.to, isScroll)
        }
    }
    
    private func autoScrollEnd(_ scrollView: UIScrollView) {
        autoScrollPercent(scrollView, false)
        self.pageScrollInfo = nil
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
    
    public func scrollToPage(to: Int, callScrollListener:Bool = true) {
        let from = self.currentIndex
        self.currentIndex = to
        
        if (self.view != nil) {
            if callScrollListener {
                self.pageScrollInfo = ArgoKitViewPageScrollInfo(isScroll: true, from: from, to: to)
            }
            self.viewPage.scrollToItem(at: NSIndexPath(item: to, section: 0) as IndexPath, at: .centeredHorizontally, animated: true)
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
        self.externalScrollListener = scrollListener
    }
    
    internal func setTabInternalScrollingListener(_ listener: ViewPageTabScrollingListener?) {
        self.innerScrollListener = listener
    }
}
