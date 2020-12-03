//
//  ArgoKitRefreshConst.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/2.
//

import Foundation
public struct ArgoKitRefreshConst {
    static let labelLeftInset: CGFloat = 25.0
    static let headerHeight: CGFloat = 54.0
    static let footerHeight: CGFloat = 44.0
    static let fastAnimationDuration = 0.25
    static let slowAnimationDuration = 0.4
}
public struct ArgoKitRefreshKeyPath {
    static let contentOffset = "contentOffset"
    static let contentInset = "contentInset"
    static let contentSize = "contentSize"
    static let panState = "state"
}
public struct ArgoKitRefreshHead {
    static let lastUpdateTimeKey = "JRefreshHeaderLastUpdateTimeKey"
    static let idleText = "JRefreshHeaderIdleText"
    static let pullingText = "JRefreshHeaderPullingText"
    static let refreshingText = "JRefreshHeaderRefreshingText"
    
    static let lastTimeText = "JRefreshHeaderLastTimeText"
    static let dateTodayText = "JRefreshHeaderDateTodayText"
    static let noneLastDateText = "JRefreshHeaderNoneLastDateText"
}

public struct ArgoKitRefreshAutoFoot {
    static let idleText = "JRefreshAutoFooterIdleText"
    static let refreshingText = "JRefreshAutoFooterRefreshingText"
    static let noMoreDataText = "JRefreshAutoFooterNoMoreDataText"
}


public let JRefreshLabelFont = UIFont.boldSystemFont(ofSize: 14)
public let JRefreshLabelTextColor = UIColor(red: 90.0 / 255.0, green: 90.0 / 255.0, blue: 90.0 / 255.0, alpha: 1.0)
