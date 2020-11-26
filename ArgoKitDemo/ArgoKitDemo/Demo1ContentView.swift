//
//  Demo1ContentView.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/11/2.
//

import Foundation
import UIKit
import ArgoKit

protocol Food { }
class Meat: Food {
    init() {
        print("das")
    }
    convenience init(_ value:Bool){
        self.init()
    }
}
struct Grass: Food { }
protocol Animal {
    associatedtype F
    func eat(_ food: F)
}
let meat = Meat()
struct Tiger: Animal {
    typealias F = Meat
    func eat(_ food: Meat) {
        print("eat \(meat)")
    }
}

extension Array {
    subscript(input: [Int]) -> ArraySlice<Element> {
        get {
            var result = ArraySlice<Element>()
            for i in input {
                assert(i < self.count, "Index out of range")
                result.append(self[i])
            }
            return result
        }

        set {
            for (index,i) in input.enumerated() {
                assert(i < self.count, "Index out of range")
                self[i] = newValue[index]
            }
        }
    }
}
precedencegroup DotProductPrecedence {
    associativity: none
    higherThan: MultiplicationPrecedence
}

infix operator +*: DotProductPrecedence
protocol Vehicle
{
    var numberOfWheels: Int {get}
    var color: UIColor {get set}

    mutating func changeColor()
}

struct MyCar: Vehicle {
    let numberOfWheels = 4
    var color = UIColor.blue

    mutating func changeColor() {
        // 因为 `color` 的类型是 `UIColor`，这里直接写 .red 就足以推断类型了
        color = .red
    }
    
    func incrementor2(variable:Int) -> Int {
        var num = variable
        num += 1
        return num
    }
    
    func logIfTrue(_ predicate: @autoclosure () -> Bool) {
        if predicate() {
            print("True")
        }
    }
    
    func makeIncrementor(addNumber: Int) -> ((inout Int) -> ()) {
        func incrementor(variable: inout Int) -> () {
            variable += addNumber;
        }
        return incrementor;
    }

}




public class SessionItem:ArgoKitIdentifiable{
    public var identifier: String
    public var reuseIdentifier: String
    var imagePath:String?
    var sessionName:String?
    var lastMessage:String?
    var timeLabel:String?
    var unreadCount:String?
    
    var textCom:Text?
    var hidden:Bool = false
    
    init(identifier:String,reuseIdentifier:String) {
        self.identifier = identifier
        self.reuseIdentifier = reuseIdentifier
    }
    
}

protocol Copyable {
    func copy() -> Self
}
class MyClass: Copyable {
    var aNil: String? = nil

//    var anotherNil: String?? = aNil
//    var literalNil: String?? = nil
//    
//    var date: NSDate {
//         willSet {
//             let d = date
//             print("即将将日期从 \(d) 设定至 \(newValue)")
//         }
//
//         didSet {
//             print("已经将日期从 \(oldValue) 设定至 \(date)")
//         }
//    }
    required init(){
//        date = NSDate()
    }
    var num = 1
    func copy() -> Self {
        let result = type(of: self).init()
        result.num = num
        return result

    }
}
