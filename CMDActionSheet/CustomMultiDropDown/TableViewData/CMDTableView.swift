//
//  CustomMultiDropdownTableView.swift
//  Enjay CRM
//
//  Created by Prifiyia on 11/05/22.
//

import UIKit

open class CMDTableView<T: Equatable>: UITableView {
    weak var selectionMenu                          : CustomMultiDropdown<T>?
    var selectionDataSource                         : CMDTableViewDataSource<T>?
    var selectionDelegate                           : CMDTableViewDelegate<T>?
    var selectionSearchDelegate                     : CMDSearchDelegate?
    var selectionStyle                              : SelectionStyle = .single
    var cellSelectionStyle                          : CellSelectionStyle = .tickmark
    
}
