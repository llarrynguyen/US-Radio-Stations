//
//  UISearchBar+Extensions.swift
//  StockPerformance
//
//  Created by Larry Nguyen on 2/27/19.
//  Copyright © 2019 Larry. All rights reserved.
//


#if canImport(UIKit) && os(iOS)
import UIKit

// MARK: - Properties
public extension UISearchBar {
    
    /// SwifterSwift: Text field inside search bar (if applicable).
    public var textField: UITextField? {
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }
    
    public var button: UITextField? {
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UIButton }).first as? UIButton else {
            return nil
        }
        return button
    }
    
    /// SwifterSwift: Text with no spaces or new lines in beginning and end (if applicable).
    public var trimmedText: String? {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}

// MARK: - Methods
public extension UISearchBar {
    
    /// SwifterSwift: Clear text.
    public func clear() {
        text = ""
    }
    
}
#endif
