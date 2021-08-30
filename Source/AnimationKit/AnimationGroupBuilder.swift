//
//  AnimationGroupBuilder.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/25.
//

import Foundation

/// The element of animation that used to describe the animation group properties you want to set.
public enum AnimationGroupElement {
    
    /// Attach this animation group to the specific UIKit view.
    case view(UIView)
    
    /// Specifies the amount of time (measured in seconds) to wait before beginning the animations.
    case delay(Float)
    
    /// Determines the number of times the animation group will repeat.
    case repeatCount(Int)
    
    /// Sets a Boolean value that controls whether that repeats this animation group forever.
    case repeatForever(Bool)
    
    /// Determines if the animation group plays in the reverse upon completion.
    case autoReverse(Bool)
    
    /// Sets multiple animations to be grouped.
    case animations(Array<Animation>)
}

extension AnimationGroup {
    
    /// Builds animation group with elements.
    /// - Parameter elements: The element of the animation group.
    /// - Returns: The animation group object.
    ///
    /// ```
    ///         let config: [AnimationGroupElement] = [
    ///             .view(view)
    ///             .animations([Animation])
    ///         ]
    ///         let animationGroup = AnimationGroup.build(config)
    /// ```
    ///
    public static func build(_ elements: [AnimationGroupElement]) -> AnimationGroup {
        let group = AnimationGroup()
        for item in elements {
            switch item {
            case .view(let value):
                group.attach(value)
            case .delay(let value):
                group.delay(value)
            case .repeatCount(let value):
                group.repeatCount(value)
            case .repeatForever(let value):
                group.repeatForever(value)
            case .autoReverse(let value):
                group.autoReverse(value)
            case .animations(let values):
                group.animations(values)
            }
        }
        return group
    }
}

/// A custom parameter attribute that constructs animations from closures.
@resultBuilder
public struct ArgoKitAnimationBuilder {
    /// Passes animations written as animation group through unmodified.
    public static func buildBlock(_ items: Animation...) -> AnimationBasic {
        if items.count == 1 {
            return items.first!
        }
        let group = AnimationGroup()
        group.animations(items)
        return group
    }
}

/// A custom parameter attribute that constructs animations from closures.
@resultBuilder
public struct ArgoKitAnimationsBuilder {
    /// Passes animations written as animation group through unmodified.
    public static func buildBlock(_ items: Animation...) -> [Animation] {
        return items
    }
}
