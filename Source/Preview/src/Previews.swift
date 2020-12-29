//
//  Preview.swift
//  ArgoKitPreview
//
//  Created by Dai on 2020-12-14.
//
#if canImport(SwiftUI) 
import Foundation
import SwiftUI

extension String {
    public static var iPhone8: String { "iPhone 8" }
    public static var iPhone8Plus: String { "iPhone 8 Plus" }
    
    public static var iPhoneSE: String { "iPhone SE" }
    public static var iPhoneXS: String { "iPhone XS" }
    public static var iPhoneXSMax: String { "iPhone XS Max" }
    
    public static var iPhone11: String { "iPhone 11" }
    public static var iPhone11Pro: String { "iPhone 11 Pro" }
    public static var iPhone11ProMax: String { "iPhone 11 Pro Max" }
    
    public static var iPhone12: String { "iPhone 12" }
    public static var iPhone12Pro: String { "iPhone 12 Pro" }
    public static var iPhone12ProMax: String { "iPhone 12 Pro Max" }
    public static var iPhone12Mini: String { "iPhone 12 Mini" }
}

extension CGSize {
    public static var iPhone8Size: CGSize { .init(width: 375, height: 667) }
    public static var iPhone8PlusSize: CGSize { .init(width: 414, height: 736) }

    public static var iPhoneSESize: CGSize { .init(width: 375, height: 667) }
    public static var iPhoneXSSize: CGSize { .init(width: 375, height: 812) }
    public static var iPhoneXSMaxSize: CGSize { .init(width: 414, height: 896) }

    public static var iPhone11Size: CGSize { .init(width: 414, height: 896) }
    public static var iPhone11ProSize: CGSize { .init(width: 375, height: 812) }
    public static var iPhone11ProMaxSize: CGSize { .init(width: 414, height: 896) }

    public static var iPhone12Size: CGSize { .init(width: 390, height: 844) }
    public static var iPhone12ProSize: CGSize { .init(width: 390, height: 844) }
    public static var iPhone12ProMaxSize: CGSize { .init(width: 428, height: 926) }
    public static var iPhone12MiniSize: CGSize { .init(width: 360, height: 780) }
}

@available(iOS 13.0, *)
extension SwiftUI.PreviewDevice {
    public static var iPhone8: SwiftUI.PreviewDevice { .init(rawValue: .iPhone8) }
    public static var iPhone8Plus: SwiftUI.PreviewDevice { .init(rawValue: .iPhone8Plus) }
    
    public static var iPhoneSE: SwiftUI.PreviewDevice { .init(rawValue: .iPhoneSE) }
    public static var iPhoneXS: SwiftUI.PreviewDevice { .init(rawValue: .iPhoneXS) }
    public static var iPhoneXSMax: SwiftUI.PreviewDevice { .init(rawValue: .iPhoneXSMax) }
    
    public static var iPhone11: SwiftUI.PreviewDevice { .init(rawValue: .iPhone11) }
    public static var iPhone11Pro: SwiftUI.PreviewDevice { .init(rawValue: .iPhone11Pro) }
    public static var iPhone11ProMax: SwiftUI.PreviewDevice { .init(rawValue: .iPhone11ProMax) }
    
    public static var iPhone12: SwiftUI.PreviewDevice { .init(rawValue: .iPhone12) }
    public static var iPhone12Pro: SwiftUI.PreviewDevice { .init(rawValue: .iPhone12Pro) }
    public static var iPhone12ProMax: SwiftUI.PreviewDevice { .init(rawValue: .iPhone12ProMax) }
    public static var iPhone12Mini: SwiftUI.PreviewDevice { .init(rawValue: .iPhone12Mini) }
}

@available(iOS 13.0, *)
public struct ArgoKitPreviewDevice: Identifiable {
    public let name: String
    public let device: SwiftUI.PreviewDevice
    public var id: String { self.name }
    public var size: CGSize
    
    public static var iPhone8: ArgoKitPreviewDevice { .init(name: .iPhone8, device: .iPhone8, size: .iPhone8Size) }
    public static var iPhone8Plus: ArgoKitPreviewDevice { .init(name: .iPhone8Plus, device: .iPhone8Plus, size: .iPhone8PlusSize) }

    public static var iPhoneSE: ArgoKitPreviewDevice { .init(name: .iPhoneSE, device: .iPhoneSE, size: .iPhoneSESize) }
    public static var iPhoneXS: ArgoKitPreviewDevice { .init(name: .iPhoneXS, device: .iPhoneXS, size: .iPhoneXSSize) }
    public static var iPhoneXSMax: ArgoKitPreviewDevice { .init(name: .iPhoneXSMax, device: .iPhoneXSMax, size: .iPhoneXSMaxSize) }

    public static var iPhone11: ArgoKitPreviewDevice { .init(name: .iPhone11, device: .iPhone11, size: .iPhone11Size) }
    public static var iPhone11Pro: ArgoKitPreviewDevice { .init(name: .iPhone11Pro, device: .iPhone11Pro, size: .iPhone11ProSize) }
    public static var iPhone11ProMax: ArgoKitPreviewDevice { .init(name: .iPhone11ProMax, device: .iPhone11ProMax, size: .iPhone11ProMaxSize) }

    public static var iPhone12: ArgoKitPreviewDevice { .init(name: .iPhone12, device: .iPhone12, size: .iPhone12Size) }
    public static var iPhone12Pro: ArgoKitPreviewDevice { .init(name: .iPhone12Pro, device: .iPhone12Pro, size: .iPhone12ProSize) }
    public static var iPhone12ProMax: ArgoKitPreviewDevice { .init(name: .iPhone12ProMax, device: .iPhone12ProMax, size: .iPhone12ProMaxSize) }
    public static var iPhone12Mini: ArgoKitPreviewDevice { .init(name: .iPhone12Mini, device: .iPhone12Mini, size: .iPhone12MiniSize) }

}

@available(iOS 13.0, *)
extension SwiftUI.ForEach where Data == [ArgoKitPreviewDevice], ID == String, Content: SwiftUI.View {
    public init(_ data: [ArgoKitPreviewDevice], @ViewBuilder content: @escaping (ArgoKitPreviewDevice) -> Content) {
        self.init(data, id:\.id, content: content)
    }
}
#endif
