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
    public static var iPhoneXE: String { "iPhone XE" }
    public static var iPhoneXEMax: String { "iPhone XE Max" }
    
    public static var iPhone11: String { "iPhone 11" }
    public static var iPhone11Pro: String { "iPhone 11 Pro" }
    public static var iPhone11ProMax: String { "iPhone 11 Pro Max" }
    
    public static var iPhone12: String { "iPhone 12" }
    public static var iPhone12Pro: String { "iPhone 12 Pro" }
    public static var iPhone12ProMax: String { "iPhone 12 Pro Max" }
    public static var iPhone12Mini: String { "iPhone 12 Mini" }
}

@available(iOS 13.0, *)
extension SwiftUI.PreviewDevice {
    public static var iPhone8: SwiftUI.PreviewDevice { .init(rawValue: .iPhone8) }
    public static var iPhone8Plus: SwiftUI.PreviewDevice { .init(rawValue: .iPhone8Plus) }
    
    public static var iPhoneSE: SwiftUI.PreviewDevice { .init(rawValue: .iPhoneSE) }
    public static var iPhoneXE: SwiftUI.PreviewDevice { .init(rawValue: .iPhoneXE) }
    public static var iPhoneXEMax: SwiftUI.PreviewDevice { .init(rawValue: .iPhoneXEMax) }
    
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
    
    public static var iPhone8: ArgoKitPreviewDevice { .init(name: .iPhone8, device: .iPhone8) }
    public static var iPhone8Plus: ArgoKitPreviewDevice { .init(name: .iPhone8Plus, device: .iPhone8Plus) }

    public static var iPhoneSE: ArgoKitPreviewDevice { .init(name: .iPhoneSE, device: .iPhoneSE) }
    public static var iPhoneXE: ArgoKitPreviewDevice { .init(name: .iPhoneXE, device: .iPhoneXE) }
    public static var iPhoneXEMax: ArgoKitPreviewDevice { .init(name: .iPhoneXEMax, device: .iPhoneXEMax) }

    public static var iPhone11: ArgoKitPreviewDevice { .init(name: .iPhone11, device: .iPhone11) }
    public static var iPhone11Pro: ArgoKitPreviewDevice { .init(name: .iPhone11Pro, device: .iPhone11Pro) }
    public static var iPhone11ProMax: ArgoKitPreviewDevice { .init(name: .iPhone11ProMax, device: .iPhone11ProMax) }

    public static var iPhone12: ArgoKitPreviewDevice { .init(name: .iPhone12, device: .iPhone12) }
    public static var iPhone12Pro: ArgoKitPreviewDevice { .init(name: .iPhone12Pro, device: .iPhone12Pro) }
    public static var iPhone12ProMax: ArgoKitPreviewDevice { .init(name: .iPhone12ProMax, device: .iPhone12ProMax) }
    public static var iPhone12Mini: ArgoKitPreviewDevice { .init(name: .iPhone12Mini, device: .iPhone12Mini) }

}
#endif
