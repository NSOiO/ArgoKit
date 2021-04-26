//
//  ArgoKitExtension.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/3.
//

import Foundation

public enum ArgoValue {
    case undefined
    case auto
    case point(CGFloat)
    case percent(CGFloat)
}
postfix operator %
extension Int {
    public static postfix func %(value: Int) -> ArgoValue {
        return .percent(CGFloat(value))
    }
}

extension Float {
    public static postfix func %(value: Float) -> ArgoValue {
        return .percent(CGFloat(value))
    }
}
extension CGFloat {
    public static postfix func %(value: CGFloat) -> ArgoValue {
        return .percent(CGFloat(value))
    }
}

extension Double {
    public static postfix func %(value: Double) -> ArgoValue {
        return .percent(CGFloat(value))
    }
}

extension ArgoValue : ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    public init(integerLiteral value: Int) {
        self = .point(CGFloat(value))
    }
    public init(floatLiteral value: Float) {
        self = .point(CGFloat(value))
    }
    public init(_ value: Float) {
        self = .point(CGFloat(value))
    }
    public init(_ value: Double) {
        self = .point(CGFloat(value))
    }
    public init(_ value: CGFloat) {
        self = .point(CGFloat(value))
    }
}
