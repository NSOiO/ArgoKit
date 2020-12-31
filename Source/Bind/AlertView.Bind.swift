//
//  AlertView.Bind.swift
//  ArgoKit
//
//  Created by xindong on 2020/12/30.
//

import Foundation

/*
@available(iOS 9.0, *)
open var preferredAction: UIAlertAction?


open func addTextField(configurationHandler: ((UITextField) -> Void)? = nil)
 */
extension AlertView {
    
    /// Sets the title of the alert.
    /// - Parameter value: The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
    /// - Returns: self
    @discardableResult
    public func titile(_ value: String?) -> Self {
        alerView.title = value
        return self
    }
    
    /// Sets descriptive text that provides additional details about the reason for the alert.
    /// - Parameter value: Descriptive text that provides additional details about the reason for the alert.
    /// - Returns: self
    @discardableResult
    public func message(_ value: String?) -> Self {
        alerView.message = value
        return self
    }
}
