//
//  Constants.swift
//  CMDActionSheet
//
//  Created by Prifiyia on 11/05/22.
//

import Foundation
import UIKit

public typealias DataSource<T: Equatable> = [T]

public typealias UITableViewCellSelection<T: Equatable> = ((_ items: T?,_ index: Int, _ selected: Bool, _ selectedItems: DataSource<T>) -> () )

public typealias UISearchBarResult<T: Equatable> = ((_ searchText: String) -> (FilteredDataSource<T>))

public typealias FilteredDataSource<T: Equatable> = [T]

typealias UITableViewCellConfiguration<T: Equatable> = ((_ cell: UITableViewCell, _ item: T, _ indexPath: IndexPath) -> ())
