//
//  ArgoKitFontExtension.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/18.
//

import Foundation

// MARK: - UIFont
public enum AKFontStyle{
    case `default`
    case bold
    case italic
    case bolditalic
}

extension UIFont{
    public class func font(fontName:String?,fontStyle:AKFontStyle? = .default,fontSize:CGFloat? = 17.0)->UIFont{
        var retFont:UIFont = UIFont.preferredFont(forTextStyle: TextStyle.body)
        var fontDescriptor:UIFontDescriptor = retFont.fontDescriptor
        if let name = fontName {
            if isFontRegistered(fontName: name) {
                fontDescriptor = UIFontDescriptor(name: name, size: fontSize ?? 17.0)
            }
        }
        switch fontStyle {
        case .bold:
            var traits = fontDescriptor.symbolicTraits
            traits = UIFontDescriptor.SymbolicTraits(rawValue: traits.rawValue | UIFontDescriptor.SymbolicTraits.traitBold.rawValue)
            fontDescriptor = fontDescriptor.withSymbolicTraits(traits) ?? fontDescriptor
            break
        case .italic:
            let matrix:CGAffineTransform = CGAffineTransform(a: 1.0, b: 0, c: CGFloat(tanf(Float(5.0 * Double.pi/180.0))), d: 1.0, tx: 0, ty: 0)
            fontDescriptor = fontDescriptor.withMatrix(matrix)
            break
        case .bolditalic:
            var traits = fontDescriptor.symbolicTraits
            traits = UIFontDescriptor.SymbolicTraits(rawValue: traits.rawValue | UIFontDescriptor.SymbolicTraits.traitBold.rawValue)
            fontDescriptor = fontDescriptor.withSymbolicTraits(traits) ?? fontDescriptor
            let matrix:CGAffineTransform = CGAffineTransform(a: 1.0, b: 0, c: CGFloat(tanf(Float(5.0 * Double.pi/180.0))), d: 1.0, tx: 0, ty: 0)
            fontDescriptor = fontDescriptor.withMatrix(matrix)
            break
        default:
            break
        }
        retFont = UIFont(descriptor: fontDescriptor, size: fontSize ?? 17.0)
        return retFont
    }
    
    private class func isFontRegistered(fontName:String)->Bool{
        var isRegistered:Bool = false
        if let aFont =  UIFont(name: fontName, size: 12.0){
            isRegistered = (aFont.fontName.compare(fontName) == .orderedSame) || (aFont.familyName.compare(fontName) == .orderedSame)
        }
        return isRegistered
    }
}

// MARK: - DispatchQueue
public extension DispatchQueue {

    private static var _onceTracker = [String]()
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.

     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    class func once(token: String, block:()->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }

        if _onceTracker.contains(token) {
            return
        }

        _onceTracker.append(token)
        block()
    }
}


protocol Lock {
    func lock()
    func unlock()
}

extension NSRecursiveLock : Lock {
    @inline(__always)
    final func performLocked<T>(_ action: () -> T) -> T {
        self.lock();
        defer { self.unlock() }
        return action()
    }
}
