//
//  CustomMultiDropdownTableViewDataSource.swift
//  Enjay CRM
//
//  Created by Prifiyia on 11/05/22.
//

import UIKit
open class CMDTableViewDataSource<T: Equatable>: NSObject, UITableViewDataSource {
    
    weak var selectionTableView                                     : CMDTableView<T>?
    var dataSource: DataSource<T>                                   = []
    fileprivate var filteredDataSource: FilteredDataSource<T>       = []
    fileprivate var cellConfiguration                               : UITableViewCellConfiguration<T>?
    
    var cellType : CellType {
        return selectionTableView?.cellType ?? .basic
    }
    
    var cellIdentifier: String {
        switch cellType {
        case .customNib(_, let identifier):
            return identifier
        default:
            return cellType.value()
        }
    }
    
    var count: Int {
        return filteredDataSource.count
    }
    
    init(dataSource: DataSource<T>, forCellType type: CellType, cellConfiguration: @escaping UITableViewCellConfiguration<T>) {
        self.dataSource = dataSource
        self.filteredDataSource = self.dataSource
        self.cellConfiguration = cellConfiguration
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getResuableCell(forTableView: tableView, indexPath: indexPath)
        guard let configuration = cellConfiguration else { return cell}
        let item = self.getObject(indexpath: indexPath)
        configuration(cell, item, indexPath)
        let delegate = tableView.delegate as! CMDTableViewDelegate<T>
        let selected = delegate.showSelected(item: item, inTableView: tableView as! CMDTableView<T>)
        self.updateStatus(selected, forCell: cell, atIndexPath: indexPath)
        return cell
    }
    
    fileprivate func getResuableCell(forTableView tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch cellType {
        case .customNib(_,_):
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            return cell
        default:
            let cell = UITableViewCell(style: self.tableViewCellStyle(), reuseIdentifier: cellIdentifier)
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.numberOfLines = 0
            cell.selectionStyle = .none
            return cell
        }
    }
}
extension CMDTableViewDataSource {
    
    fileprivate func tableViewCellStyle() -> UITableViewCell.CellStyle {
        
        switch self.cellType {
        case .basic:
            return UITableViewCell.CellStyle.default
        default:
            return UITableViewCell.CellStyle.default
        }
    }
    //return the object in datasource on a specific path
    
    func getObject(indexpath: IndexPath) -> T {
        return filteredDataSource[indexpath.row]
    }
    
    func update(dataSource: DataSource<T>, inTableView tableView: CMDTableView<T>) {
        filteredDataSource = dataSource
        tableView.reload()
    }
    
    func updateStatus(_ status: Bool, forCell cell: UITableViewCell, atIndexPath indexPath: IndexPath){
        
        guard selectionTableView?.cellSelectionStyle == .checkbox else {
            cell.accessoryType = status ? .checkmark : .none
            return
        }
        
        switch cellType {
        case .customNib, .customClass:
            break
        default:
            cell.setSelected(status, animated: true)
            return
        }
        if status {
            selectionTableView?.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }else {
            selectionTableView?.deselectRow(at: indexPath, animated: false)
        }
    }
}
