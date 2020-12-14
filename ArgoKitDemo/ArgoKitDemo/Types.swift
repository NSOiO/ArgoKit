//
//  Types.swift
//  ArgoKitPreview
//
//  Created by Dai on 2020-11-25.
//

#if canImport(SwiftUI) && canImport(ArgoKit) && DEBUG
import ArgoKit
import SwiftUI

typealias UIHostingController = ArgoKit.UIHostingController
typealias View = ArgoKit.View
typealias VStack = ArgoKit.VStack
typealias HStack = ArgoKit.HStack

typealias AlertView = ArgoKit.AlertView
typealias ForEach = ArgoKit.ForEach
typealias BlurEffectView = ArgoKit.BlurEffectView
typealias Button = ArgoKit.Button

typealias Gesture = ArgoKit.Gesture
typealias TapGesture = ArgoKit.TapGesture
typealias SwipeGesture = ArgoKit.SwipeGesture
typealias PinchGesture = ArgoKit.PinchGesture
typealias RotationGesture = ArgoKit.RotationGesture
typealias PanPressGesture = ArgoKit.PanPressGesture
typealias LongPressGesture = ArgoKit.LongPressGesture
typealias ScreenEdgePanGesture = ArgoKit.ScreenEdgePanGesture

typealias Image = ArgoKit.Image
typealias PageControl = ArgoKit.PageControl
typealias ProgressView = ArgoKit.ProgressView
typealias SegmenteControl = ArgoKit.SegmenteControl
typealias Slider = ArgoKit.Slider
typealias Spacer = ArgoKit.Spacer
typealias Stepper = ArgoKit.Stepper
typealias Text = ArgoKit.Text
typealias Toggle = ArgoKit.Toggle
typealias List = ArgoKit.List
typealias DatePicker = ArgoKit.DatePicker
typealias PickerView = ArgoKit.PickerView
typealias ScrollView = ArgoKit.ScrollView
typealias TextField = ArgoKit.TextField
typealias TextView = ArgoKit.TextView
typealias TabSegment = ArgoKit.TabSegment

//typealias SessionItem = ArgoKit.SessionItem


extension String {
    public static var iPhoneSE: String { "iPhone SE" }
    public static var iPhoneXEMax: String { "iPhone XE Max" }
    public static var iPhone11ProMax: String { "iPhone 11 Pro Max" }
}

extension PreviewDevice {
    public static var iPhoneSE: PreviewDevice { .init(rawValue: .iPhoneSE) }
    public static var iPhoneXEMax: PreviewDevice { .init(rawValue: .iPhoneXEMax) }
    public static var iPhone11ProMax: PreviewDevice { .init(rawValue: .iPhone11ProMax) }
}

#endif

