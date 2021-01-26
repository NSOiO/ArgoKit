//
//  Action.swift
//  ArgoKit
//
//  Created by Dai on 2021-01-26.
//

import Foundation

#if false

public struct Action : RawRepresentable, Equatable, Hashable, Comparable {

//    public typealias RawValue = String
    public var rawValue: String

    public static let None  = Action(rawValue: "None")
    public static let Tap = Action(rawValue: "Tap")
    public static let LongPress = Action(rawValue: "LongPress")
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    //MARK: Hashable
    public var hashValue: Int {
        return rawValue.hashValue
    }

    //MARK: Comparable
    public static func <(lhs: Action, rhs: Action) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    public static func ==(lhs: Action, rhs: Action) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
#else
public protocol Action {}
public struct None: Action { public init(){} }
public struct Tap: Action { public init(){} }
public struct LongPress: Action { public init(){} }
#endif
