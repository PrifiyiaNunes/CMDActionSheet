//
//  Enums.swift
//  CMDActionSheet
//
//  Created by Prifiyia on 11/05/22.
//

import Foundation
import UIKit

public enum SelectionStyle {
    case single        // default
    case multiple
}

public enum CellSelectionStyle {
    case tickmark
    case checkbox
}

public enum PresentationStyle {
    case alert(title: String?, action: String?, height: Double?)
    case actionSheet(title: String?, action: String?, height: Double?)
}

public enum CellType {
    
    case basic          // default
    case customNib(nibName: String, cellIdentifier: String)
    case customClass(type: AnyClass, cellIdentifier: String)
    
    /// Get Value
    func value() -> String {
        return "basic"
    }
}
