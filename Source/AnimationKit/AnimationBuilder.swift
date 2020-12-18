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
    case view(UIView?)
    case delay(Float)
    case duration(Float)
    case repeatCount(Int)
    case repeatForever(Bool)
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
