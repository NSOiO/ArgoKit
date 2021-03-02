//
//  TabSegment.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/30.
//

import Foundation

private let DefaultProgressBarWidth: Float = 20
private let DefaultAnimationDuration: Float = 0.25
private let DefaultItemSpaceValue: Float = 15
private let DefaultScaleFromValue: Float = 1.0
private let DefaultScaleToValue: Float = 1.3

public class TabSegment: View {
    
    // MARK: - Private
    private let _node: ArgoKitTabSegmentNode
    private var _contentNodes: [ArgoKitNode] = []
    
    private var _datas: [Any] = []
    private var _createContentItem: ((Any)->View)?
    private let _itemSpaceValue: Float
    
    private var _animType: AnimationType = .scale // default
    private var _fromValue: AnimationValue?
    private var _toValue: AnimationValue?
    private var _isDoingAnimation = false
    private var _scaleAnimationProgress: Float = 0.0
    private var _animCache: [AnyHashable:Array<Any>] = [:]
    
    private var _fromIndex: Int = -1
    private var _toIndex: Int = 0
    private var _displayLink: CADisplayLink?
    private var _innerClickCallback: ((Int,Bool)->Void)?
    private var _externalClickCallback: ((Int)->Void)?
    
    private let containerNodeObserver = ArgoKitNodeObserver()
    private let itemStackNodeObserver = ArgoKitNodeObserver()
    private let itemNodeObserver = ArgoKitNodeObserver()
    private let progressBarNodeObserver = ArgoKitNodeObserver()
    
    public var node: ArgoKitNode? { _node }
    
    private let _container: VStack = {
        return VStack().alignSelf(.stretch)
    }()
    
    private let _contentView: HStack = {
        return HStack().padding(top: 15, right: 30, bottom: 10, left: 0)
            .justifyContent(.evenly).alignSelf(.stretch).alignItems(.stretch)
    }()
    
    private let _progressBar: Image = {
        return Image().backgroundColor(.black).width(ArgoValue(DefaultProgressBarWidth)).height(5).cornerRadius(2)
    }()
    
    private var _scrollView: UIScrollView? {
        if let scrollView = _node.view as? UIScrollView {
            return scrollView
        }
        return nil
    }
    
    // MARK: - Public
    public init(_ itemSpace: Float) {
        _itemSpaceValue = itemSpace
        _node = ArgoKitTabSegmentNode(viewClass: UIScrollView.self)
        _node.row();
        _node.maxWidth(percent: 100)
        _node.addChildNode(_container.node!)
    }
    
    convenience public init(_ datas: Array<Any>, @ArgoKitViewBuilder content: @escaping (Any) -> View) {
        self.init(datas, itemSpace: DefaultItemSpaceValue, content: content)
    }
    
    convenience public init(_ datas: Array<Any>, itemSpace: Float, @ArgoKitViewBuilder content: @escaping (Any) -> View) {
        self.init(itemSpace)
        _contentView.node?.row()
        _container.node?.addChildNode(_contentView.node!)
        _container.node?.addChildNode(_progressBar.node!)
        
        _createContentItem = content
        createSubviews(datas, content)
        setupNodeObserver()
    }
    
    @discardableResult
    public func animType(_ type: AnimationType) -> Self {
        _animType = type
        return self
    }
    
    @discardableResult
    public func animFromValue(_ values: AnimationValue) -> Self {
        _fromValue = values
        return self
    }
    
    @discardableResult
    public func animToValue(_ values: AnimationValue) -> Self {
        _toValue = values
        return self
    }
    
    @discardableResult
    public func select(index: Int) -> Self {
        guard _toIndex != index else {
            return self
        }
        guard index > -1 && index < _contentNodes.count else {
            assertionFailure("The index is invalid, it should be greater than -1 and less than \(_contentNodes.count) (TabSegment subviews count is \(_contentNodes.count)). ")
            return self
        }
        _toIndex = index
        return self
    }
    
    @discardableResult
    public func scroll(_ fromIndex: Int, _ toIndex: Int, _ progress: Float, _ scrollFinish: Bool) -> Self {
        guard toIndex > -1 && toIndex < _contentNodes.count else {
            assertionFailure("The toIndex is invalid, it should be greater than -1 and less than \(_contentNodes.count) (TabSegment subviews count is \(_contentNodes.count)). ")
            return self
        }
        if scrollFinish {
            _fromIndex = fromIndex
            _toIndex = toIndex
            resetAnimationState()
            return self
        }
        if _toIndex == toIndex {
            return self
        }
        if fromIndex == toIndex {
            return self
        }
        _isDoingAnimation = true
        updateContentUI(fromIndex, toIndex, max(min(1, progress), 0), false)
        return self
    }
    
    @discardableResult
    public func clickedCallback(_ callback: @escaping (Int) -> Void) -> Self {
        _externalClickCallback = callback
        return self
    }
    
    // MARK: Internal
    internal func clickedInternalCallback(_ callback: ((Int, Bool) -> Void)?) {
        _innerClickCallback = callback
    }
    
}

extension TabSegment {
    private func createSubviews(_ datas: Array<Any>, _ content: ((Any) -> View)?) {
        guard let createItem = content else { return }
        guard datas.isEmpty == false else {
            assertionFailure("The datas parameter has no elements.")
            return
        }
        _datas = datas
        
        for (_, data) in datas.enumerated() {
            let container = createItem(data)
            if let node = container.type.viewNodes()?.first {
                node.marginLeft(point: 0)
                node.marginRight(point: 0)
                node.addNode(observer: itemNodeObserver)
                _contentNodes.append(node)
                let stack = HStack().onTapGesture {
                    let index = self._contentNodes.firstIndex(of: node)!
                    self.clickContentItem(index, true)
                }
                stack.node?.marginTop(point: 10)
                stack.node?.addChildNode(node)
                stack.node?.addNode(observer: itemStackNodeObserver)
                stack.node?.marginLeft(point: CGFloat(_itemSpaceValue))
                _contentView.node?.addChildNode(stack.node!)
            }
        }
    }
    
    private func setupNodeObserver() {
        _container.node?.addNode(observer: containerNodeObserver)
        _progressBar.node?.addNode(observer: progressBarNodeObserver)
        
        containerNodeObserver.setFrameChange { [self] (frame) in
            if let scrollView = _node.view as? UIScrollView {
                if _animType == .scale || _animType == .scaleX {
                    let from_to = dereferenceScaleValue()
                    let scale = (from_to.1 - from_to.0) / Float(_contentNodes.count) + from_to.0
                    let size = CGSize(width: frame.width * CGFloat(scale), height: frame.height)
                    scrollView.contentSize = size
                } else {
                    scrollView.contentSize = frame.size
                }
            }
        }
        itemStackNodeObserver.setCreateViewBlock { view in
            let frame = view.frame
            view.layer.anchorPoint = CGPoint(x: 0, y: 1)
            view.frame = frame
        }
        itemNodeObserver.setCreateViewBlock { (view) in
            self.doContentItemViewScaleAnimation(view, false, 1.0)
        }
        progressBarNodeObserver.setCreateViewBlock { (view) in
            self.clickContentItem(nil, false) // 在TabSegment上所有子视图创建完再执行默认初始动画(progressBar为最后一个子视图)
        }
    }
    
    private func clickContentItem(_ index: Int?, _ anim: Bool) {
        if index == _toIndex || _isDoingAnimation {
            return
        }
        let toIndex = index ?? _toIndex
        if let callback = _innerClickCallback {
            callback(toIndex, anim)
        }
        if let callback = _externalClickCallback {
            callback(toIndex)
        }
        _fromIndex = _toIndex
        _toIndex = toIndex
        updateContentUI(_fromIndex, toIndex, 1.0, anim)
        
        _isDoingAnimation = true
        if anim {
            let duration: Int = Int(DefaultAnimationDuration * 1000)
            DispatchQueue.main.asyncAfter(deadline:.now() + .milliseconds(duration)) {
                self.resetAnimationState()
            }
        } else {
            resetAnimationState()
        }
    }
    
    private func updateContentUI(_ fromIndex: Int, _ toIndex: Int, _ progress: Float, _ autoAnim: Bool) {
        if _animType == .scale || _animType == .scaleX {
            prepareContentItemViewScaleAnimation(fromIndex, toIndex, progress, autoAnim)
        } else {
            doContentItemViewOtherAnimation(fromIndex, toIndex, progress, autoAnim)
        }
        doProgressBarAnimation(fromIndex, toIndex, progress, autoAnim)
        doScrollViewContentOffsetAnimation(toIndex, progress, autoAnim)
    }
    
    private func resetAnimationState() {
        _isDoingAnimation = false
        _animCache.removeAll()
    }
}

extension TabSegment {
    
    private func prepareContentItemViewScaleAnimation(_ fromIndex: Int, _ toIndex: Int, _ progress: Float, _ autoAnim: Bool) {
        if autoAnim {
            removeScaleAnimationDisplayLink()
            createScaleAnimationDisplayLink()
        } else {
            updateItemViewScaleAnimation(fromIndex, toIndex, progress)
        }
    }

    private func removeScaleAnimationDisplayLink() {
        if let link = _displayLink {
            link.remove(from: .main, forMode: .common)
            link.invalidate()
            _displayLink = nil
            _scaleAnimationProgress = 0.0
        }
    }
    
    private func createScaleAnimationDisplayLink() {
        _displayLink = CADisplayLink.init(target: self, selector: #selector(scaleAnimationDisplayLinkCallback(_:)))
        _displayLink?.add(to: RunLoop.main, forMode: .common)
    }
    
    @objc func scaleAnimationDisplayLinkCallback(_ displayLink: CADisplayLink) -> Void {
        if _scaleAnimationProgress >= 1.0 {
            removeScaleAnimationDisplayLink()
        } else {
            _scaleAnimationProgress += 0.07
            _scaleAnimationProgress = max(0.0, min(_scaleAnimationProgress, 1.0))
            updateItemViewScaleAnimation(_fromIndex, _toIndex, _scaleAnimationProgress)
        }
    }
    
    private func updateItemViewScaleAnimation(_ fromIndex: Int, _ toIndex: Int, _ progress: Float) {
        if fromIndex > -1 {
            let old = _contentNodes[fromIndex]
            doContentItemViewScaleAnimation(old.view, false, progress)
        }
        if toIndex > -1 {
            let new = _contentNodes[toIndex]
            doContentItemViewScaleAnimation(new.view, true, progress)
        }
        
        var left = _itemSpaceValue
        for item in _contentNodes { // 调整每个item的frame.origin.x
            if let superview = item.view?.superview {
                var frame = superview.akAnimationFrame
                frame.origin.x = CGFloat(left)
                superview.akAnimationFrame = frame
                let xScale = superview.layer.sublayerTransform.m11
                let scaleWidth = xScale * frame.width;
                left += Float(scaleWidth) + _itemSpaceValue
            }
        }
    }
}

extension TabSegment {
    
    private func doContentItemViewScaleAnimation(_ view: UIView?, _ positive: Bool, _ progress: Float) {
        guard let itemView = view else {
            return
        }
        let from_to = dereferenceScaleValue()
        let from = from_to.0
        let to = from_to.1
        
        var scale: Float = 1.0
        if positive {
            scale = from + (to - from) * progress
        } else {
            scale = to + (from - to) * progress
        }
        
        if let superview = itemView.superview {
            let transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
            superview.layer.sublayerTransform = CATransform3DMakeAffineTransform(transform)
        }
    }
    
    private func doContentItemViewOtherAnimation(_ fromIndex: Int, _ toIndex: Int, _ progress: Float, _ autoAnim: Bool) {
        guard _animType != .scale && _animType != .scaleX else {
            assertionFailure("The scale animation of TabSegment should implement by using Timer.")
            return
        }
        guard let toValue = _toValue else {
            assertionFailure("You must call `animToValue` method firstly.")
            return
        }

        let startAnimation = { [self] (index: Int, from: AnimationValue?, to: AnimationValue) in
            if let view = _contentNodes[index].view {
                var cachAnim: Animation?
                if let cache = _animCache[view] {
                    cachAnim = cache.first as? Animation
                } else {
                    cachAnim = Animation(type: _animType)
                    cachAnim?.attach(view)
                    _animCache[view] = [cachAnim!]
                }
                if let anim = cachAnim {
                    resolveValuesForAnimation(anim, from, to)
                    if autoAnim {
                        anim.duration(DefaultAnimationDuration)
                        anim.start()
                    } else {
                        anim.update(progress: progress)
                    }
                }
            }
        }
        
        if fromIndex > -1 {
            if (_fromValue == nil) {
                if let view = _contentNodes[toIndex].view {
                    _fromValue = currentAnimationValueForView(view)
                }
            }
            let newFromValue = toValue
            guard let newToValue = _fromValue else { return }
            startAnimation(fromIndex, newFromValue, newToValue)
        }
        
        if toIndex > -1 {
            startAnimation(toIndex, _fromValue, toValue)
        }
    }
    
    private func doProgressBarAnimation(_ fromIndex: Int, _ toIndex: Int, _ progress: Float, _ autoAnim: Bool) {
        var fromView: UIView?
        if fromIndex > -1 {
            fromView = _contentNodes[fromIndex].view?.superview
        }
        guard let toView = _contentNodes[toIndex].view?.superview else {
            return
        }
        
        var cachePosX: Animation?
        var cacheWidth: AnimationGroup?
        if let cache = _animCache[_progressBar.node] {
            cachePosX = cache.first as? Animation
            cacheWidth = cache.last as? AnimationGroup
        } else {
            cachePosX = Animation(type: .positionX)
            cachePosX?.attach(_progressBar)
            let widthAnim1 = Animation(type: .scaleX)
            widthAnim1.attach(_progressBar)
            let offset = (fromView != nil) ? (abs(ViewCenterX(toView) - ViewCenterX(fromView!)) / Float((abs(toIndex - fromIndex) + 2))) : 0
            let maxWidth = DefaultProgressBarWidth + offset
            widthAnim1.from(1).to(maxWidth / DefaultProgressBarWidth)
            widthAnim1.duration(DefaultAnimationDuration / 2)
            
            let widthAnim2 = Animation(type: .scaleX)
            widthAnim2.attach(_progressBar)
            widthAnim2.from(maxWidth / DefaultProgressBarWidth).to(1)
            widthAnim2.duration(DefaultAnimationDuration / 2)
            
            cacheWidth = AnimationGroup()
            cacheWidth?.animations([widthAnim1, widthAnim2])
            
            _animCache[_progressBar.node] = [cachePosX!, cacheWidth!]
        }

        guard let posXAnim = cachePosX else { return }
        guard let widthGroup = cacheWidth else { return }

        posXAnim.to((itemViewCenterX(toIndex) - DefaultProgressBarWidth / 2))
        posXAnim.duration(DefaultAnimationDuration)
        
        if autoAnim {
            posXAnim.start()
            widthGroup.serial(true).start()
        } else {
            posXAnim.update(progress: progress)
            widthGroup.serial(true).update(progress: progress)
        }
    }
    
    private func doScrollViewContentOffsetAnimation(_ toIndex: Int, _ progress: Float, _ autoAnim: Bool) {
        var cachAnim: Animation?
        if let cache = _animCache[_scrollView] {
            cachAnim = cache.first as? Animation
        } else {
            cachAnim = Animation(type: .contentOffset)
            cachAnim?.attach(self)
            _animCache[_scrollView] = [cachAnim!]
        }
        guard let anim = cachAnim else { return }
        
        var offset: Float = 0.0
        let centerX = itemViewCenterX(toIndex)
        let width = Float(_scrollView?.frame.width ?? 0)
        let contentSizeWidth = Float(_scrollView?.contentSize.width ?? 0)
        if centerX < width / 2 {
            offset = 0
        } else if centerX > contentSizeWidth - width / 2 {
            let contentWidth: Float = (contentSizeWidth > width) ? contentSizeWidth : width
            offset = contentWidth - width
        } else {
            offset = centerX - width / 2
        }
        anim.to(offset, 0)
        if autoAnim {
            anim.duration(DefaultAnimationDuration)
            anim.start()
        } else {
            anim.update(progress: progress)
        }
    }
}

extension TabSegment {
    private func resolveValuesForAnimation(_ anim: Animation, _ from: AnimationValue?, _ to: AnimationValue) {
        switch from {
        case .float(let value):
            anim.from(value)
        case .float2(let value1, let value2):
            anim.from((value1, value2))
        case .float4(let value1, let value2, let value3, let value4):
            anim.from((value1, value2, value3, value4))
        case .color(let value):
            anim.from(value)
        default:
            break
        }

        switch to {
        case .float(let value):
            anim.to(value)
        case .float2(let value1, let value2):
            anim.to((value1, value2))
        case .float4(let value1, let value2, let value3, let value4):
            anim.to((value1, value2, value3, value4))
        case .color(let value):
            anim.to(value)
        default:
            break
        }
    }
    
    private func currentAnimationValueForView(_ view: UIView) -> AnimationValue {
        switch _animType {
        case .alpha:
            return .float(Float(view.alpha))
        case .color:
            return .color(view.backgroundColor ?? .white)
        case .contentOffset:
            let offset = (view as! UIScrollView).contentOffset
            return .float2(Float(offset.x), Float(offset.y))
        case .position:
            return .float2(Float(view.frame.minX), Float(view.frame.minY))
        case .positionX:
            return .float(Float(view.frame.minX))
        case .positionY:
            return .float(Float(view.frame.minY))
        case .rotation:
            return .float2(0, 0)
        case .rotationX:
            return .float(0)
        case .rotationY:
            return .float(0)
        case .scale:
            return .float2(1.0, 1.0)
        case .scaleX:
            return .float(1.0)
        case .scaleY:
            return .float(1.0)
        case .textColor:
            return .color((view as! UILabel).textColor)
        }
    }
    
    private func dereferenceScaleValue() -> (Float, Float) {
        var from: Float = DefaultScaleFromValue
        var to: Float = DefaultScaleToValue
        switch _fromValue {
        case .float(let value): from = value
        case .float2(let value, _): from = value
        default: break
        }
        switch _toValue {
        case .float(let value): to = value
        case .float2(let value, _): to = value
        default: break
        }
        return (from, to)
    }
    
    private func ViewCenterX(_ view: UIView) -> Float {
        return Float(view.frame.origin.x + view.frame.size.width / 2)
    }
    
    private func itemViewCenterX(_ itemIndex: Int) -> Float {
        var fromScale: Float = 1.0
        var toScale: Float = 1.0
        if _animType == .scale || _animType == .scaleX {
            let from_to = dereferenceScaleValue()
            fromScale = from_to.0
            toScale = from_to.1
        }

        var xOffset: Float = 0.0
        for (i, node) in _contentNodes.enumerated() {
            guard let nodeStackView = node.view?.superview else {
                continue
            }
            if i == itemIndex {
                xOffset += _itemSpaceValue + Float(nodeStackView.bounds.width) * toScale / 2
                break
            }
            xOffset += _itemSpaceValue + Float(nodeStackView.bounds.width) * fromScale
        }
        return xOffset
    }
}
