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
