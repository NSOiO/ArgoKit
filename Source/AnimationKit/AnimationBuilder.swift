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


public enum AnimationElement {
    case type(AnimationType)
    case duration(Float)
    case repeatCount(Int)
    case autoReverse(Bool)
    case timingFunc(AnimationTimingFunc)
    case from(AnimationValue)
    case to(AnimationValue)
    
    public static func from(_ v1: Float) -> Self {
        return .from(AnimationValue.float(v1))
    }
    public static func from(_ v1: Float, _ v2: Float) -> Self {
        return .from(AnimationValue.float2(v1, v2))
    }
    public static func from(_ v1: Float, _ v2: Float, _ v3: Float, _ v4: Float) -> Self {
        return .from(AnimationValue.float4(v1, v2, v3, v4))
    }
    public static func from(_ color: UIColor) -> Self {
        return .from(AnimationValue.color(color))
    }
    
    public static func to(_ v1: Float) -> Self {
        return .to(AnimationValue.float(v1))
    }
    public static func to(_ v1: Float, _ v2: Float) -> Self {
        return .to(AnimationValue.float2(v1, v2))
    }
    public static func to(_ v1: Float, _ v2: Float, _ v3: Float, _ v4: Float) -> Self {
        return .to(AnimationValue.float4(v1, v2, v3, v4))
    }
    public static func to(_ color: UIColor) -> Self {
        return .to(AnimationValue.color(color))
    }
}

extension Animation {
    public static func build(elements: [AnimationElement]) -> Animation {
        // TODO...
        return Animation(type: .alpha)
    }
}
