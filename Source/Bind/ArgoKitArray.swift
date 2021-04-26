//
//  ArgoKitArray.swift
//  ArgoKit
//
//  Created by Dai on 2021-01-13.
//

import Foundation

public struct ArgoKitArray<Element> {
    internal var array = [Element]()
    internal init(_ array: [Element]) {
        self.array = array
    }
}

internal extension ArgoKitArray {
    var count: Int{ get { self.array.count } }
    mutating func append(_ newElement:Element) {
        self.array.append(newElement)
    }
    
    mutating func append<S>(contentsOf newElements: S) where S : Sequence, Element == S.Element {
        self.array.append(contentsOf: newElements)
    }
    
    mutating func insert(_ newElement: Element, at i: Int) {
        self.array.insert(newElement, at: i)
    }
    
    mutating func insert<C>(contentsOf newElements: C, at i: Int) where C : Collection, Element == C.Element {
        self.array.insert(contentsOf: newElements, at: i)
    }
    
    mutating func removeAll(keepingCapacity keepCapacity: Bool = false) {
        self.array.removeAll(keepingCapacity: keepCapacity)
    }
    
    mutating func remove(at position: Int) -> Element {
        self.array.remove(at: position)
    }
    
    var first: Element? { get { self.array.first } }
    var last: Element? { get { self.array.last } }

    subscript(index: Int) -> Element {
        get { self.array[index] }
        set { self.array[index] = newValue }
    }
}

extension ArgoKitArray : ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.array = elements
    }
}

extension ArgoKitArray : Sequence {
    public typealias Iterator = IndexingIterator<[Element]>
    public func makeIterator() -> Iterator {
        self.array.makeIterator()
    }
}

