//
//  AlertView.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/16.
//

import Foundation

@objcMembers class ArgokitAlertViewNode: ArgoKitNode {
    public dynamic var isPresented: Bool = false
    private var alertController: UIAlertController
    var observer: NSKeyValueObservation!
    
    public init(alertController: UIAlertController) {
        self.alertController = alertController
        super.init(viewClass: UIView.self)
    }
}

/// Wrapper of UIAlertController
/// An object that displays an alert message to the user.
public class AlertView: View {
    let pNode: ArgokitAlertViewNode
    let alerView: UIAlertController
    var pTextField: UITextField?
    
    /// The node behind the alert view.
    public var node: ArgoKitNode? {
        pNode
    }
    
    /// Initializer
    /// - Parameters:
    ///   - title: The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
    ///   - message: Descriptive text that provides additional details about the reason for the alert.
    ///   - preferredStyle: The style to use when presenting the alert controller. Use this parameter to configure the alert controller as an action sheet or as a modal alert.
    public init(title: String? = "", message: String? = "", preferredStyle: UIAlertController.Style) {
        alerView = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        pNode = ArgokitAlertViewNode(alertController: alerView)
    }
}

extension AlertView {
    
    /// Add default style Action.
    /// - Parameters:
    ///   - title: The text to use for the button title. The value you specify should be localized for the user’s current language.
    ///   - handler: A block to execute when the user selects the action. This block has no return value and takes the selected action object as its only parameter.
    /// - Returns: Self
    @discardableResult
    public func `default`(title: String?, handler: ((String?) -> Void)?) -> Self {
        let alertAction:UIAlertAction = UIAlertAction(title: title, style: UIAlertAction.Style.default) { [weak self] action in
            if let block = handler {
                block(self?.pTextField?.text)
            }
        }
        alerView.addAction(alertAction)
        return self
    }
    
    /// Add cancel style Action.
    /// - Parameters:
    ///   - title: The text to use for the button title. The value you specify should be localized for the user’s current language.
    ///   - handler: A block to execute when the user selects the action. This block has no return value and takes the selected action object as its only parameter.
    /// - Returns: Self
    @discardableResult
    public func cancel(title: String?, handler: (() -> Void)?) -> Self {
        let alertAction:UIAlertAction = UIAlertAction(title: title, style: UIAlertAction.Style.cancel) { action in
            if let block = handler {
                block()
            }
        }
        alerView.addAction(alertAction)
        return self
    }
    
    /// Add destructive style Action.
    /// - Parameters:
    ///   - title: The text to use for the button title. The value you specify should be localized for the user’s current language.
    ///   - handler: A block to execute when the user selects the action. This block has no return value and takes the selected action object as its only parameter.
    /// - Returns: Self
    @discardableResult
    public func destructive(title: String?, handler: ((String?) -> Void)?) -> Self {
        let alertAction:UIAlertAction = UIAlertAction(title: title, style: UIAlertAction.Style.destructive) { [weak self] action in
            if let block = handler {
                block(self?.pTextField?.text)
            }
        }
        alerView.addAction(alertAction)
        return self
    }
    
    /// Add TextField.
    /// - Returns: Self
    @discardableResult
    public func textField() -> Self {
        alerView.addTextField { [weak self] textFiled in
            self?.pTextField = textFiled
        }
        return self
    }
    
    /// Present alert view
    public func show() {
        if let viewController = self.rootViewController() {
            viewController.present(alerView, animated: true, completion: nil)
        }
    }
}
/*
@available(iOS 9.0, *)
open var preferredAction: UIAlertAction?


open func addTextField(configurationHandler: ((UITextField) -> Void)? = nil)
 */
extension AlertView {
    
    /// Set the title of the alert.
    /// - Parameter value: The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
    /// - Returns: Self
    @discardableResult
    public func titile(_ value: String?) -> Self {
        alerView.title = value
        return self
    }
    
    /// Set descriptive text that provides additional details about the reason for the alert.
    /// - Parameter value: Descriptive text that provides additional details about the reason for the alert.
    /// - Returns: Self
    @discardableResult
    public func message(_ value: String?) -> Self {
        alerView.message = value
        return self
    }
}

extension View {
    
    /// Add alert View
    /// - Parameter content: the builder of alert View
    /// - Returns: Self
    @discardableResult
    public func alert(_ content:()->AlertView) -> Self{
        let alertView = content()
        if let node = alertView.node {
            self.node!.addChildNode(node)
        }
        return self
    }
}
