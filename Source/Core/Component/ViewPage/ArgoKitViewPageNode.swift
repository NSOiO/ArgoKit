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
    lazy var registedReuseIdSet = Set<String>()
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
    private var gestures:[UIGestureRecognizer]?
    public var viewPage:UICollectionView {
        self.view as! UICollectionView
    }
    
    override func clearStrongRefrence() {
        super.clearStrongRefrence()
        self.pDataSourceHelper.removeAll()
        if let  _ = self.pDataSourceHelper.nodeSourceList{
            self.pDataSourceHelper.nodeSourceList?.clear()
        }
    }
    
    private lazy var viewPageLayout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy var dataSourceHelper = DataSourceHelper<D>()
    var pDataSourceHelper = DataSourceHelper<D>()
    private var isReuseEnable:Bool = true
    
    private var _pageCount:Int = 0
    private var pageCount:Int{
        set{
            if let collectionNode =  self.reusedNode as? ArgoKitViewPageNode{
                collectionNode._pageCount = newValue
                return
            }
            _pageCount = newValue
        }
        get{
            if let collectionNode =  self.reusedNode as? ArgoKitViewPageNode{
                return collectionNode._pageCount
            }
            return _pageCount
        }
    }
    private var nodeCurrentIndex:Int = 0
    private var _currentIndex:Int = 0
    private var currentIndex:Int{
        set{
            if let collectionNode =  self.reusedNode as? ArgoKitViewPageNode{
                collectionNode._currentIndex = newValue
                return
            }
            _currentIndex = newValue
        }
        get{
            if let collectionNode =  self.reusedNode as? ArgoKitViewPageNode{
                return collectionNode._currentIndex
            }
            return _currentIndex
        }
    }
    
    private var itemSpacing:CGFloat = 0.0
    
    private var _isScrolling:Bool = false
    private var isScrolling:Bool{
        set{
            _isScrolling = newValue
            if let collectionNode =  self.reusedNode as? ArgoKitViewPageNode{
                collectionNode._isScrolling = newValue
                return
            }
            _isScrolling = newValue
        }
        get{
            if let collectionNode =  self.reusedNode as? ArgoKitViewPageNode{
                return collectionNode._isScrolling
            }
            return _isScrolling
        }
    }
    
    private var _pageChangedFunc:ViewPageChangedCloser?
    private var pageChangedFunc:ViewPageChangedCloser?{
        set{
            _pageChangedFunc = newValue
        }
        get{
            if let collectionNode =  self.reusedNode as? ArgoKitViewPageNode{
                return collectionNode._pageChangedFunc
            }
            return _pageChangedFunc
        }
    }
    
    private var _pageScrollInfo: ArgoKitViewPageScrollInfo?
    private var pageScrollInfo: ArgoKitViewPageScrollInfo?{
        set{
            _pageScrollInfo = newValue
        }
        get{
            if let collectionNode =  self.reusedNode as? ArgoKitViewPageNode{
                return collectionNode._pageScrollInfo
            }
            return _pageScrollInfo
        }
    }
    private var _innerScrollListener: ViewPageTabScrollingListener?
    private var innerScrollListener: ViewPageTabScrollingListener?{
        set{
            _innerScrollListener = newValue
        }
        get{
            if let collectionNode =  self.reusedNode as? ArgoKitViewPageNode{
                return collectionNode._innerScrollListener
            }
            return _innerScrollListener
        }
    }
    private var _externalScrollListener: ViewPageTabScrollingListener?
    private var externalScrollListener: ViewPageTabScrollingListener?{
        set{
            _externalScrollListener = newValue
        }
        get{
            if let collectionNode =  self.reusedNode as? ArgoKitViewPageNode{
                return collectionNode._externalScrollListener
            }
            return _externalScrollListener
        }
    }
    
    
    private var hasScrollListener: Bool {(innerScrollListener != nil) || (externalScrollListener != nil)}
    
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let collectionView = ArgoKitViewPage(frame: frame, collectionViewLayout: viewPageLayout)
        collectionView.reLayoutAction = { [weak self] frame in
            if let `self` = self {
                var cellNodes:[Any] = []
                cellNodes.append(contentsOf: self.pDataSourceHelper.cellNodeCache)
                ArgoKitReusedLayoutHelper.reLayoutNode(cellNodes, frame: frame)
            }
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bouncesZoom = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isPrefetchingEnabled = false
        
        if self.currentIndex > 0 {
            DispatchQueue.main.async {
                collectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0) as IndexPath, at: .centeredHorizontally, animated: false)
            }
        }
        self.gestures = collectionView.gestureRecognizers
        return collectionView
    }
    
    override func reuseNodeToView(node: ArgoKitNode, view: UIView?) {
        super.reuseNodeToView(node: node, view: view)
        if let collectionNode =  node as? ArgoKitViewPageNode,
           let collectionView = view as? UICollectionView {
            self.pDataSourceHelper = collectionNode.dataSourceHelper
            self.reusedNode = collectionNode
            
            if let gestures_ = collectionView.gestureRecognizers,
               gestures_.count > 0{
                if let gestures = self.gestures{
                    for gesture in gestures {
                        if !gestures_.contains(gesture)  {
                            collectionView.addGestureRecognizer(gesture)
                        }
                    }
                }
            }else{
                if let gestures = self.gestures{
                    for gesture in gestures {
                        collectionView.addGestureRecognizer(gesture)
                    }
                }
            }
            
            collectionView.reloadData()
            if collectionNode.nodeCurrentIndex > 0 {
                collectionNode.currentIndex = collectionNode.nodeCurrentIndex
                DispatchQueue.main.async {
                    collectionView.scrollToItem(at: NSIndexPath(item: collectionNode.currentIndex, section: 0) as IndexPath, at: .centeredHorizontally, animated: false)
                }
            }
        }
    }
    
    override func prepareForUse(view: UIView?) {
        super.prepareForUse(view: view)

        if let collectionView = view as? UICollectionView {
            self.pDataSourceHelper = DataSourceHelper<D>()
            self.reusedNode = nil
            collectionView.reloadData()
            DispatchQueue.main.async {
                collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize.zero
    }
// MARK: UICollectionViewDataSource

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.pDataSourceHelper.numberOfRows(section: section)
        if count > 0 {
            return count
        }
        return self.pageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var identifier = self.pDataSourceHelper.reuseIdForRow(indexPath.row, at: indexPath.section) ?? kCellReuseIdentifier
        let node = self.pDataSourceHelper.nodeForRow(indexPath.item, at: indexPath.section)
        if self.isReuseEnable == false, let node_ = node{
            identifier = identifier + "_\(indexPath.section)_\(indexPath.row)" + String(node_.hashValue)
        }
        if let collectionView_ = collectionView as? ArgoKitViewPage,
            !collectionView_.registedReuseIdSet.contains(identifier) {
            collectionView_.register(ArgoKitViewPageCell.self, forCellWithReuseIdentifier: identifier)
            collectionView_.registedReuseIdSet.insert(identifier)
        }
        let cell = viewPage.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ArgoKitViewPageCell
        if let node_ = node {
            cell.linkCellNode(node_)
        }
        return cell
    }
    
    
// MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.collectionView(_:didSelectItemAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section)  {
            let sel = #selector(self.collectionView(_:layout:sizeForItemAt:))
            if let size_ = self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? CGSize,!size_.equalTo(CGSize.zero){
                var maxWidth = size_.width - self.itemSpacing
                if size_.width <= 0 {
                    maxWidth = collectionView.frame.width - self.itemSpacing;
                    self.pDataSourceHelper.rowHeight(indexPath.row, at: indexPath.section, maxWidth: maxWidth,maxHeight: size_.height)
                    return CGSize(width: maxWidth, height: size.height)
                }
                self.pDataSourceHelper.rowHeight(indexPath.row, at: indexPath.section, maxWidth: maxWidth,maxHeight: size_.height)
                return size_
            }
        }
        let width = collectionView.frame.width - self.itemSpacing;
        let height = collectionView.frame.height
        return CGSize(width: width, height: self.pDataSourceHelper.rowHeight(indexPath.row, at: indexPath.section, maxWidth: width,maxHeight: height))
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
            let count = self.pDataSourceHelper.numberOfRows(section: 0)
            var item:Any? = nil
            if count > toIndex && toIndex >= 0 {
                item = self.pDataSourceHelper.dataForRow(toIndex, at: 0);
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
    public func setCurrentPageIndex(_ pageIndex: Int) {
        self.nodeCurrentIndex = pageIndex
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
