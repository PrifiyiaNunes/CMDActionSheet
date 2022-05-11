
//  CustomMultiDropdown.swift
//  CMDActionSheet
//
//  Created by Prifiyia on 11/05/22.

import UIKit
open class CustomMultiDropdown<T: Equatable>: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - Views
    public var tableView: CMDTableView<T>?

    /// SearchBar
    public var searchBar: UISearchBar? {
        return tableView?.searchControllerDelegate?.searchBar
    }

    /// NavigationBar
    public var navigationBar: UINavigationBar? {
        return self.navigationController?.navigationBar
    }

    // MARK: - Properties

    /// dismiss: for Single selection only
    public var dismissAutomatically: Bool = true

    /// Barbuttons titles
    public var leftBarButtonTitle: String?
    public var rightBarButtonTitle: String?

    /// cell selection style
    public var cellSelectionStyle: CellSelectionStyle = .tickmark {
        didSet {
            self.tableView?.setCellSelectionStyle(cellSelectionStyle)
        }
    }

    /// maximum selection limit
    public var maxSelectionLimit: UInt? = nil {
        didSet {
            self.tableView?.selectionDelegate?.maxSelectedLimit = maxSelectionLimit
        }
    }

    /// Selection menu willAppear handler
    public var onWillAppear:(() -> ())?

    /// Selection menu dismissal handler
    public var onDismiss:((_ selectedItems: DataSource<T>) -> ())?

    /// RightBarButton Tap handler - Only for Multiple Selection & Push, Present - Styles
    /// Note: This is override the default dismiss behaviour of the menu.
    /// onDismiss will not be called if this is implemeted. (dismiss manually in this completion block)
    public var onRightBarButtonTapped:((_ selectedItems: DataSource<T>) -> ())?

    // MARK: - Private

    /// store reference view controller
    fileprivate weak var parentController: UIViewController?

    /// presentation style
    fileprivate var menuPresentationStyle: PresentationStyle = .present

    /// navigationbar theme
    fileprivate var navigationBarTheme: NavigationBarTheme?

    /// backgroundView
    fileprivate var backgroundView = UIView()


    // MARK: - Init

    convenience public init(
        dataSource: DataSource<T>,
        tableViewStyle: UITableView.Style = .plain,
        cellConfiguration configuration: @escaping UITableViewCellConfiguration<T>) {

        self.init(
            selectionStyle: .single,
            dataSource: dataSource,
            tableViewStyle: tableViewStyle,
            cellConfiguration: configuration
        )
    }

    convenience public init(
        selectionStyle: SelectionStyle,
        dataSource: DataSource<T>,
        tableViewStyle: UITableView.Style = .plain,
        cellConfiguration configuration: @escaping UITableViewCellConfiguration<T>) {

        self.init(
            selectionStyle: selectionStyle,
            dataSource: dataSource,
            tableViewStyle: tableViewStyle,
            cellType: .basic,
            cellConfiguration: configuration
        )
    }

    convenience public init(
        selectionStyle: SelectionStyle,
        dataSource: DataSource<T>,
        tableViewStyle: UITableView.Style = .plain,
        cellType: CellType,
        cellConfiguration configuration: @escaping UITableViewCellConfiguration<T>) {

        self.init()

        // data source
        let selectionDataSource = RSSelectionMenuDataSource<T>(
            dataSource: dataSource,
            forCellType: cellType,
            cellConfiguration: configuration
        )

        // delegate
        let selectionDelegate = RSSelectionMenuDelegate<T>(selectedItems: [])

        // initilize tableview
        self.tableView = RSSelectionTableView<T>(
            selectionStyle: selectionStyle,
            tableViewStyle: tableViewStyle,
            cellType: cellType,
            dataSource: selectionDataSource,
            delegate: selectionDelegate,
            from: self
        )
    }

    // MARK: - Life Cycle

    override open func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayout()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView?.reload()
        if let handler = onWillAppear { handler() }
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        view.endEditing(true)

        /// on dimiss not called in iPad for multi select popover
        if tableView?.selectionStyle == .multiple, popoverPresentationController != nil {
            self.menuWillDismiss()
        }
    }

    // MARK: - Setup Views
    fileprivate func setupViews() {
        backgroundView.backgroundColor = UIColor.clear

        if case .formSheet = menuPresentationStyle {
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            addTapGesture()
        }

        backgroundView.addSubview(tableView!)
        view.addSubview(backgroundView)

        // rightBarButton
        if showRightBarButton() {
            setRightBarButton()
        }

        // leftBarButton
        if showLeftBarButton() {
            setLeftBarButton()
        }
    }

    // MARK: - Setup Layout

    fileprivate func setupLayout() {
        if let frame = parentController?.view.bounds {
            self.view.frame = frame
        }
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setTableViewFrame()
    }

    /// tableView frame
    fileprivate func setTableViewFrame() {
        self.backgroundView.frame = self.view.bounds
        self.tableView?.frame = backgroundView.frame
    }

    /// Tap gesture
    fileprivate func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onBackgroundTapped(sender:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        backgroundView.addGestureRecognizer(tapGesture)
    }

    @objc func onBackgroundTapped(sender: UITapGestureRecognizer){
        self.dismiss()
    }
}
