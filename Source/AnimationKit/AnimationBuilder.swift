//
//  AnimationBuilder.swift
//  ArgoKit
//
//  Created by Dai on 2020-11-19.
//

import Foundation

public enum AnimationValue {
    case null
    case float(Float)
    case float2(Float,Float)
    case float4(Float,Float,Float,Float)
    case color(UIColor)
}

/// The element of animation that used to describe the animation properties you want to set.
public enum AnimationElement {
    
    /// Sets the type of the animation.
    case type(AnimationType)
    
    /// Attach this animation to the specific UIKit view.
    case view(UIView?)
    
    /// Specifies the amount of time (measured in seconds) to wait before beginning the animations.
    case delay(Float)
    
    /// Specifies the basic duration of the animation, in seconds.
    case duration(Float)
    
    /// Determines the number of times the animation will repeat.
    case repeatCount(Int)
    
    /// Sets a Boolean value that controls whether that repeats this animation forever.
    case repeatForever(Bool)
    
    /// Determines if the animation plays in the reverse upon completion.
    case autoReverse(Bool)
    
    /// Sets an optional timing function defining the pacing of the animation.
    case timingFunc(AnimationTimingFunc)
    
    /// Defines the value the animation uses to start interpolation.
    case from(AnimationValue)
    
    /// Defines the value the animation uses to end interpolation.
    case to(AnimationValue)
    
    /// Defines the float value the animation uses to start interpolation.
    /// - Parameter v1: The float value the animation uses to end interpolation.
    /// - Returns: Self
    public static func from(_ v1: Float) -> Self {
        return .from(AnimationValue.float(v1))
    }
    
    /// Defines the point value the animation uses to start interpolation.
    /// - Parameters:
    ///   - v1: The x of the point.
    ///   - v2: The y of the point.
    /// - Returns: Self
    public static func from(_ v1: Float, _ v2: Float) -> Self {
        return .from(AnimationValue.float2(v1, v2))
    }
    
    /// Defines the color value the animation uses to start interpolation.
    /// - Parameters:
    ///   - v1: The red value of the color object. 0~ 255
    ///   - v2: The green value of the color object. 0~ 255
    ///   - v3: The blue value of the color object. 0~ 255
    ///   - v4: The opacity value of the color object, specified as a value from 0.0 to 1.0.
    /// - Returns: Self
    public static func from(_ v1: Float, _ v2: Float, _ v3: Float, _ v4: Float) -> Self {
        return .from(AnimationValue.float4(v1, v2, v3, v4))
    }
    
    /// Defines the color value the animation uses to start interpolation.
    /// - Parameter color: The color value the animation uses to start interpolation.
    /// - Returns: Self
    public static func from(_ color: UIColor) -> Self {
        return .from(AnimationValue.color(color))
    }
    
    /// Defines the float value the animation uses to end interpolation.
    /// - Parameter v1: The float value the animation uses to end interpolation.
    /// - Returns: Self
    public static func to(_ v1: Float) -> Self {
        return .to(AnimationValue.float(v1))
    }
    
    /// Defines the point value the animation uses to end interpolation.
    /// - Parameters:
    ///   - v1: The x of the point.
    ///   - v2: The y of the point.
    /// - Returns: Self
    public static func to(_ v1: Float, _ v2: Float) -> Self {
        return .to(AnimationValue.float2(v1, v2))
    }
    
    /// Defines the color value the animation uses to end interpolation.
    /// - Parameters:
    ///   - v1: The red value of the color object. 0~ 255
    ///   - v2: The green value of the color object. 0~ 255
    ///   - v3: The blue value of the color object. 0~ 255
    ///   - v4: The opacity value of the color object, specified as a value from 0.0 to 1.0.
    /// - Returns: Self
    public static func to(_ v1: Float, _ v2: Float, _ v3: Float, _ v4: Float) -> Self {
        return .to(AnimationValue.float4(v1, v2, v3, v4))
    }
    
    /// Defines the color value the animation uses to end interpolation.
    /// - Parameter color: The color value the animation uses to end interpolation.
    /// - Returns: Self
    public static func to(_ color: UIColor) -> Self {
        return .to(AnimationValue.color(color))
    }
}

extension Animation {
    
    /// Builds animation with elements.
    /// - Parameter elements: The element of the animation.
    /// - Returns: The animation object.
    ///
    /// ```
    ///         let config: [AnimationElement] = [
    ///             .type(type),
    ///             .duration(duration),
    ///             .from(from),
    ///             .to(to),
    ///             .view(view)
    ///         ]
    ///         let animation = Animation.build(config)
    /// ```
    ///
    public static func build(_ elements: [AnimationElement]) -> Animation {
        var type: AnimationType?
        var view: UIView?
        var delay: Float?
        var duration: Float?
        var repeatCount: Int?
        var repeatForever: Bool?
        var autoReverse: Bool?
        var timingFunc: AnimationTimingFunc?
        var from: AnimationValue?
        var to: AnimationValue?
        
        for item in elements {
            switch item {
            case .type(let value):
                type = value
            case .view(let value):
                view = value
            case .delay(let value):
                 delay = value
            case .duration(let value):
                duration = value
            case .repeatCount(let value):
                repeatCount = value
            case .repeatForever(let value):
                repeatForever = value
            case .autoReverse(let value):
                autoReverse = value
            case .timingFunc(let value):
                timingFunc = value
            case .from(let value):
                from = value
            case .to(let value):
                to = value
            }
        }
        
        guard let t = type else {
            assertionFailure("You should specify the `.type` case of AnimationElement enumeration.")
            return Self(type: .alpha)
        }
        
        let anim = Self(type: t)
        if let v = view {
            anim.attach(v)
        }
        if let d = delay {
            anim.delay(d)
        }
        if let d = duration {
            anim.duration(d)
        }
        if let r = repeatCount {
            anim.repeatCount(r)
        }
        if let r = repeatForever {
            anim.repeatForever(r)
        }
        if let a = autoReverse {
            anim.autoReverse(a)
        }
        if let t = timingFunc {
            anim.timingFunc(t)
        }
        if let f = from {
            switch f {
            case .float(let value):
                anim.from(value)
            case .float2(let value1, let value2):
                anim.from((value1, value2))
            case .float4(let value1, let value2, let value3, let value4):
                anim.from((value1, value2, value3, value4))
            case .color(let value):
                anim.from(value)
            default: break
            }
        }
        if let t = to {
            switch t {
            case .float(let value):
                anim.to(value)
            case .float2(let value1, let value2):
                anim.to((value1, value2))
            case .float4(let value1, let value2, let value3, let value4):
                anim.to((value1, value2, value3, value4))
            case .color(let value):
                anim.to(value)
            default: break
            }
        }
        return anim
    }
}
