//
//  ArgoKitRefreshConst.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/2.
//

import Foundation
public struct RefreshConst {
    static let labelLeftInset: CGFloat = 25.0
    static let headerHeight: CGFloat = 54.0
    static let footerHeight: CGFloat = 44.0
    static let fastAnimationDuration = 0.25
    static let slowAnimationDuration = 0.4
}
public struct RefreshKeyPath {
    static let contentOffset = "contentOffset"
    static let contentInset = "contentInset"
    static let contentSize = "contentSize"
    static let panState = "state"
}
public struct ArgoKitRefreshHead {
    static let lastUpdateTimeKey = "AKRefreshHeaderLastUpdateTimeKey"
    static let idleText = "AKRefreshHeaderIdleText"
    static let pullingText = "AKRefreshHeaderPullingText"
    static let refreshingText = "AKRefreshHeaderRefreshingText"
    
    static let lastTimeText = "AKRefreshHeaderLastTimeText"
    static let dateTodayText = "AKRefreshHeaderDateTodayText"
    static let noneLastDateText = "AKRefreshHeaderNoneLastDateText"
}

public struct ArgoKitRefreshAutoFoot {
    static let idleText = "AKRefreshAutoFooterIdleText"
    static let refreshingText = "AKRefreshAutoFooterRefreshingText"
    static let noMoreDataText = "AKRefreshAutoFooterNoMoreDataText"
}


public let AKRefreshLabelFont = UIFont.boldSystemFont(ofSize: 14)
public let AKRefreshLabelTextColor = UIColor(red: 90.0 / 255.0, green: 90.0 / 255.0, blue: 90.0 / 255.0, alpha: 1.0)
