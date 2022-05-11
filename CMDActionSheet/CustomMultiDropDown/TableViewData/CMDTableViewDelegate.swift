//
//  CustomMultiDropdownTableViewDelegate.swift
//  Enjay CRM
//
//  Created by Prifiyia on 11/05/22.
//

import UIKit

open class CMDTableViewDelegate<T: Equatable>: NSObject, UITableViewDelegate {
    var selectionDelegate                               : UITableViewCellSelection<T>? = nil
    var selectedItems                                   = DataSource<T>()
    
    convenience init(selectedItems: DataSource<T>) {
        self.init()
        self.selectedItems = selectedItems
    }
    
}
extension CMDTableViewDelegate {
    public func showSelected(item: T, inTableView tableView: CMDTableView<T>) -> Bool {
        selectedItems.contains(item)
    }
}
