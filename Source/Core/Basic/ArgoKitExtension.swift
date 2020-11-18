//
//  ArgoKitExtension.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/3.
//

import Foundation
import yoga;
postfix operator %
extension Int {
    public static postfix func %(value: Int) -> ArgoValue {
        return ArgoValue(value: CGFloat(value), type: .percent)
    }
}

extension Float {
    public static postfix func %(value: Float) -> ArgoValue {
        return ArgoValue(value: CGFloat(value), type: .percent)
    }
}

extension CGFloat {
    public static postfix func %(value: CGFloat) -> ArgoValue {
        return ArgoValue(value: CGFloat(value), type: .percent)
    }
}

extension ArgoValue : ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    public init(integerLiteral value: Int) {
        if(value < 0){
            self = ArgoValue(value: CGFloat(value), type: .auto)
        }else{
            self = ArgoValue(value: CGFloat(value), type: .point)
        }
    }

    public init(floatLiteral value: Float) {
        if(value < 0){
            self = ArgoValue(value: CGFloat(value), type: .auto)
        }else{
            self = ArgoValue(value: CGFloat(value), type:  .point)
        }
        
    }

    public init(_ value: Float) {
        if(value < 0){
            self = ArgoValue(value: CGFloat(value), type: .auto)
        }else{
            self = ArgoValue(value: CGFloat(value), type:  .point)
        }
    }

    public init(_ value: CGFloat) {
        if(value < 0){
            self = ArgoValue(value: CGFloat(value), type: .auto)
        }else{
            self = ArgoValue(value: CGFloat(value), type:  .point)
        }
    }
}
