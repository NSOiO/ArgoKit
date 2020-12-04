//
//  TabSegment.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/30.
//

import Foundation

public class TabSegment: View {
    
    // MARK: - Private
    private let _node: ArgoKitTabSegmentNode
    private var _contentNodes: [ArgoKitNode] = []
    
    private var _animType: AnimationType = .scale // default
    private var _fromValue: AnimationValue?
    private var _toValue: AnimationValue?
    private var _isDoingAnimation = false
    
    private var _previousIndex: Int = -1
    private var _currentIndex: Int = -1
    private var _displayLink: CADisplayLink?
    private var _clickCallback: ((Int,Bool)->Void)?
    
    private var _scaleAnimationProgress: Float = 0.0
    private var _previousContentOffsetX: Float = 0.0
    
    private let containerNodeObserver = ArgoKitNodeObserver()
    private let itemStackNodeObserver = ArgoKitNodeObserver()
    private let progressBarNodeObserver = ArgoKitNodeObserver()
    
    private let AnimationDuration: Float = 0.25
    private let ProgressBarWidth: Float = 20
    private let ItemSpaceValue: Float = 15
    private let DefaultScaleFromValue: Float = 1.0
    private let DefaultScaleToValue: Float = 1.3
    
    private let _container: VStack = {
        return VStack().alignSelf(.stretch)
    }()
    
    private let _contentView: HStack = {
        return HStack().padding(top: 15, right: 30, bottom: 10, left: 0)
            .justifyContent(.evenly).alignSelf(.stretch).alignItems(.stretch)
    }()
    
    private lazy var _progressBar: Image = {
        return Image().backgroundColor(.black).width(ArgoValue(ProgressBarWidth)).height(5)
    }()
    
    private var _scrollView: UIScrollView? {
        if let scrollView = _node.view as? UIScrollView {
            return scrollView
        }
        return nil
    }
    
    public init() {
        _node = ArgoKitTabSegmentNode(viewClass: UIScrollView.self)
        _node.row();
        _node.maxWidth(percent: 100)
        _node.alignItemsFlexStart()
        
        _node.addChildNode(_container.node!)
        _container.node?.addChildNode(_contentView.node!)
        _container.node?.addChildNode(_progressBar.node!)
        
        setupNodeObserver()
    }
    
    // MARK: - Public
    public var node: ArgoKitNode? { _node }

    convenience public init(@ArgoKitViewBuilder content: () -> View) {
        self.init()
        
        let container = content()
        if let nodes = container.type.viewNodes() {
            _contentView.node?.row()
            for node in nodes {
                _contentNodes.append(node)
                let stack = HStack().onTapGesture {
                    let index = self._contentNodes.firstIndex(of: node)!
                    self.clickContentItem(index, true)
                }
                stack.node?.marginTop(point: 10)
                stack.node?.addChildNode(node)
                stack.node?.addNode(observer: itemStackNodeObserver)
                stack.node?.marginLeft(point: CGFloat(ItemSpaceValue))
                _contentView.node?.addChildNode(stack.node!)
            }
        }
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
        guard _currentIndex != index else {
            return self
        }
        guard index > -1 && index < _contentNodes.count else {
            assertionFailure("The index is invalid, it should be greater than -1 and less than \(_contentNodes.count) (TabSegment subviews count is \(_contentNodes.count)). ")
            return self
        }
        _currentIndex = index
        return self
    }
    
    @discardableResult
    public func scroll(toIndex: Int, progress: Float) -> Self {
        if _currentIndex != toIndex {
            updateContentUI(toIndex, progress, false)
        }
        return self
    }
    
    @discardableResult
    public func clickedCallback(_ callback: @escaping (Int, Bool) -> Void) -> Self {
        _clickCallback = callback
        return self
    }
    
    // MARK: - Private
    private func setupNodeObserver() {
        _container.node?.addNode(observer: containerNodeObserver)
        _progressBar.node?.addNode(observer: progressBarNodeObserver)
        
        containerNodeObserver.setFrameChange { [self] (frame) in
            if let scrollView = _node.view as? UIScrollView {
                scrollView.contentSize = frame.size
            }
        }
        itemStackNodeObserver.setCreateViewBlock { view in
            let frame = view.frame
            view.layer.anchorPoint = CGPoint(x: 0, y: 1)
            view.frame = frame
        }
        progressBarNodeObserver.setCreateViewBlock { (view) in
            self.clickContentItem(nil, false) // 在TabSegment上所有子视图创建完再执行默认初始动画(progressBar为最后一个子视图)
        }
    }
    
    private func clickContentItem(_ index: Int?, _ anim: Bool) {
        if index == _currentIndex || _isDoingAnimation {
            return
        }
        let toIndex = index ?? _currentIndex
        if let callback = _clickCallback {
            callback(toIndex, anim)
        }
        updateContentUI(toIndex, 1.0, anim)
    }
    
    private func updateContentUI(_ toIndex: Int, _ progress: Float, _ autoAnim: Bool) {
        _previousIndex = _currentIndex
        _currentIndex = toIndex
        let fromIndex = _previousIndex
        
        if _animType == .scale || _animType == .scaleX {
            prepareContentItemViewScaleAnimation(autoAnim, progress)
        } else {
            if fromIndex > -1 {
                let old = _contentNodes[fromIndex]
                doContentItemViewOtherAnimation(old.view, false, progress, autoAnim)
            }
            if toIndex > -1 {
                let new = _contentNodes[toIndex]
                doContentItemViewOtherAnimation(new.view, true, progress, autoAnim)
            }
        }
        doProgressBarAnimation(fromIndex, toIndex, progress, autoAnim)
        doScrollViewContentOffsetAnimation(toIndex, progress, autoAnim)
    }
    
    // MARK: - Scale Animation
    private func prepareContentItemViewScaleAnimation(_ autoAnim: Bool, _ progress: Float) {
        if autoAnim {
            removeScaleAnimationDisplayLink()
            createScaleAnimationDisplayLink()
        } else {
            updateItemViewScaleAnimation(progress)
        }
    }

    private func removeScaleAnimationDisplayLink() {
        if let link = _displayLink {
            link.remove(from: .main, forMode: .common)
            link.invalidate()
            _displayLink = nil
            _scaleAnimationProgress = 0.0
            _isDoingAnimation = false
        }
    }
    
    private func createScaleAnimationDisplayLink() {
        _displayLink = CADisplayLink.init(target: self, selector: #selector(scaleAnimationDisplayLinkCallback(_:)))
        _displayLink?.add(to: RunLoop.main, forMode: .common)
        _isDoingAnimation = true
    }
    
    @objc func scaleAnimationDisplayLinkCallback(_ displayLink: CADisplayLink) -> Void {
        if _scaleAnimationProgress >= 1.0 {
            removeScaleAnimationDisplayLink()
        } else {
            _scaleAnimationProgress += 0.07
            _scaleAnimationProgress = max(0.0, min(_scaleAnimationProgress, 1.0))
            updateItemViewScaleAnimation(_scaleAnimationProgress)
        }
    }
    
    private func updateItemViewScaleAnimation(_ progress: Float) {
        if _previousIndex > -1 {
            let old = _contentNodes[_previousIndex]
            doContentItemViewScaleAnimation(old.view, false, progress)
        }
        if _currentIndex > -1 {
            let new = _contentNodes[_currentIndex]
            doContentItemViewScaleAnimation(new.view, true, progress)
        }
        
        var left = ItemSpaceValue
        for item in _contentNodes { // 调整每个item的frame.origin.x
            if let superview = item.view?.superview {
                var frame = superview.akAnimationFrame
                frame.origin.x = CGFloat(left)
                superview.akAnimationFrame = frame
                let xScale = superview.layer.sublayerTransform.m11
                let scaleWidth = xScale * frame.width;
                left += Float(scaleWidth) + ItemSpaceValue
            }
        }
    }
    
    private func doContentItemViewScaleAnimation(_ view: UIView?, _ positive: Bool, _ progress: Float) {
        guard let itemView = view else {
            return
        }
        
        var from: Float = DefaultScaleFromValue
        switch _fromValue {
        case .float(let value):
            from = value
        case .float2(let value, _):
            from = value
        default:
            break
        }
        
        var to: Float = DefaultScaleToValue
        switch _toValue {
        case .float(let value):
            to = value
        case .float2(let value, _):
            to = value
        default:
            break
        }
        
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
    
    // MARK: - Other Animation
    private func doContentItemViewOtherAnimation(_ itemView: UIView?, _ positive: Bool, _ progress: Float, _ autoAnim: Bool) {
        guard let view = itemView else { return }
        guard _animType != .scale && _animType != .scaleX else {
            assertionFailure("The scale animation of TabSegment should implement by using Timer.")
            return
        }
        guard let to = _toValue else {
            assertionFailure("You must call `animToValue` method firstly.")
            return
        }
        
        _isDoingAnimation = true
        let anim = Animation(type: _animType)
        anim.attach(view)
        anim.finishCallback({ (_, _) in
            self._isDoingAnimation = false
        })
 
        if positive {
            resolveValuesForAnimation(anim, _fromValue, to)
        } else {
            var from = _fromValue
            if (from == nil) {
                if let view = _contentNodes[_currentIndex].view {
                    from = currentAnimationValueForView(view)
                }
            }
            guard let value = from else { return }
            resolveValuesForAnimation(anim, to, value)
        }
        
        if autoAnim {
            anim.duration(AnimationDuration)
            anim.start()
        } else {
            anim.update(progress: progress)
        }
    }
    
    // MARK: ProgressBar Animation
    private func doProgressBarAnimation(_ fromIndex: Int, _ toIndex: Int, _ progress: Float, _ autoAnim: Bool) {
        var fromView: UIView?
        if fromIndex > -1 {
            fromView = _contentNodes[fromIndex].view?.superview
        }
        guard let toView = _contentNodes[toIndex].view?.superview else {
            return
        }

        let posXAnim = Animation(type: .positionX)
        posXAnim.attach(_progressBar)
        posXAnim.to((itemViewCenterX(toIndex) - ProgressBarWidth / 2))
        posXAnim.duration(AnimationDuration)
        
        let widthAnim1 = Animation(type: .scaleX)
        widthAnim1.attach(_progressBar)
        let offset = (fromView != nil) ? (abs(ViewCenterX(toView) - ViewCenterX(fromView!)) / Float((abs(toIndex - fromIndex) + 2))) : 0
        let maxWidth = ProgressBarWidth + offset
        widthAnim1.from(1).to(maxWidth / ProgressBarWidth)
        widthAnim1.duration(AnimationDuration / 2)
        
        let widthAnim2 = Animation(type: .scaleX)
        widthAnim2.attach(_progressBar)
        widthAnim2.from(maxWidth / ProgressBarWidth).to(1)
        widthAnim2.duration(AnimationDuration / 2)
        
        let widthGroup = AnimationGroup()
        widthGroup.animations([widthAnim1, widthAnim2])
        
        if autoAnim {
            posXAnim.start()
            widthGroup.startSerial()
        } else {
            posXAnim.update(progress: progress)
            widthGroup.update(progress: progress)
        }
    }
    
    // MARK: ScrollView ContentOffset Animation
    private func doScrollViewContentOffsetAnimation(_ toIndex: Int, _ progress: Float, _ autoAnim: Bool) {
        let anim = Animation(type: .contentOffset)
        anim.attach(self)
        anim.finishCallback { (_, _) in
            if let scrollView = self._scrollView {
                self._previousContentOffsetX = Float(scrollView.contentOffset.x)
            }
        }
        
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
        anim.from(_previousContentOffsetX, 0).to(offset, 0)
        if autoAnim {
            anim.duration(AnimationDuration)
            anim.start()
        } else {
            anim.update(progress: progress)
            if progress >= 1 {
                _previousContentOffsetX = Float(_scrollView?.contentOffset.x ?? 0.0)
            }
        }
    }
    
    // MARK: -
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
    
    private func ViewCenterX(_ view: UIView) -> Float {
        return Float(view.frame.origin.x + view.frame.size.width / 2)
    }
    
    private func itemViewCenterX(_ itemIndex: Int) -> Float {
        let itemNode = _contentNodes[itemIndex]
        guard let itemStackView = itemNode.view?.superview else {
            return 0.0
        }
        guard _animType == .scale || _animType == .scaleX else {
            return ViewCenterX(itemStackView)
        }
        
        var scale: Float = DefaultScaleToValue
        switch _toValue {
        case .float(let value):
            scale = value
        case .float2(let value, _):
            scale = value
        default:
            break
        }
        let itemWidth = Float(itemStackView.frame.width)
        let xOffset = ItemSpaceValue + Float(itemIndex) * (ItemSpaceValue + itemWidth)
        return xOffset + itemWidth * scale / 2
    }
}
