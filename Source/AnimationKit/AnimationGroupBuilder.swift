//
//  AnimationGroupBuilder.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/25.
//

import Foundation

public enum AnimationGroupElement {
    case view(UIView)
    case delay(Float)
    case repeatCount(Int)
    case repeatForever(Bool)
    case autoReverse(Bool)
    case animations(Array<Animation>)
}

extension AnimationGroup {
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

@_functionBuilder
public struct ArgoKitAnimationBuilder {
    public static func buildBlock(_ items:Animation...) -> AnimationBasic {
        if items.count == 1 {
            return items.first!
        }
        let group = AnimationGroup()
        group.animations(items)
        return group
    }
}
