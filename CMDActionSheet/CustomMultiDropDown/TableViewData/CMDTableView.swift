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
    var SearchDelegate                              : CMDSearchDelegate?
    var searchResultDelegate                        : UISearchBarResult<T>?
    var selectionStyle                              : SelectionStyle = .single
    var cellSelectionStyle                          : CellSelectionStyle = .tickmark
    var cellType: CellType                          = .basic
    
    lazy var emptyDataView: UILabel = {
        let label = UILabel()
        label.center = self.center
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.darkText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    convenience public init(selectionStyle: SelectionStyle, tableViewStyle: UITableView.Style, cellType: CellType, dataSource: CMDTableViewDataSource<T>, delegate: CMDTableViewDelegate<T>, from: CustomMultiDropdown<T>) {
        
        if #available(iOS 13.0, *) {
            self.init(frame: .zero, style: tableViewStyle)
        } else {
            self.init()
        }
        
        self.selectionDataSource = dataSource
        self.selectionDelegate = delegate
        self.selectionStyle = selectionStyle
        self.selectionMenu = from
        self.cellType = cellType
        setUp()
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let _ = self.backgroundView {
            self.emptyDataView.center = self.center
        }
    }
    
    func setUp() {
        self.selectionDataSource?.selectionTableView = self
        dataSource = self.selectionDataSource
        delegate = self.selectionDelegate
        tableFooterView = UIView()
        estimatedRowHeight = 50
        rowHeight = UITableView.automaticDimension
        keyboardDismissMode = .interactive
        register(UITableView.self, forCellReuseIdentifier: CellType.basic.value())
        if case let CellType.customNib(name, cellIdentifier) = cellType {
            register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
    }
}

extension CMDTableView {
    
    func setSelection(items: DataSource<T>, onDidSelectRow delegate: @escaping UITableViewCellSelection<T>) {
        self.selectionDelegate?.selectionDelegate = delegate
        self.selectionDelegate?.selectedItems = items
    }
    
    func setCellSelectionStyle(_ style: CellSelectionStyle) {
        self.cellSelectionStyle = style
        if style == .checkbox {
            isEditing = true
            allowsMultipleSelectionDuringEditing = true
        }
    }
    
    func addSearchBar(placeHolder: String, completion: @escaping UISearchBarResult<T>) {
        self.searchResultDelegate = completion
        self.SearchDelegate = CMDSearchDelegate(placeHolder: placeHolder)
        
        self.SearchDelegate?.didSearch = { [weak self] (searchText) in
            if searchText.isEmpty {
                self?.selectionDataSource?.update(dataSource: (self?.selectionDataSource?.dataSource)!, inTableView: self!)
            }else {
                let filterDataSource = self?.searchResultDelegate!(searchText) ?? []
                self?.selectionDataSource?.update(dataSource: filterDataSource, inTableView: self!)
            }
        }
    }
}
