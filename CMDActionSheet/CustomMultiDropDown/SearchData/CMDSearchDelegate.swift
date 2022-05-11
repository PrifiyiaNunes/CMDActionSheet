//
//  CMDSearchDelegate.swift
//  CMDActionSheet
//
//  Created by Prifiyia on 11/05/22.
//

import UIKit

open class CMDSearchDelegate: NSObject {
    
    public var searchBar : UISearchBar?
    public var didSearch : ((String) -> ())?
    
    init(placeHolder: String) {
        
        super.init()
        
        searchBar = UISearchBar()
        
        searchBar?.layer.borderWidth = 0.0
        if let textfield = searchBar?.value(forKey: "searchField") as? UITextField {
            textfield.translatesAutoresizingMaskIntoConstraints = false
            if #available(iOS 9.0, *) {
                textfield.leftAnchor.constraint(equalTo: searchBar!.leftAnchor, constant: 5).isActive = true
                textfield.rightAnchor.constraint(equalTo: searchBar!.rightAnchor, constant: -5).isActive = true
                textfield.topAnchor.constraint(equalTo: searchBar!.topAnchor, constant: 5).isActive = true
                textfield.bottomAnchor.constraint(equalTo: searchBar!.bottomAnchor, constant: -5).isActive = true
            }
            textfield.clearButtonMode = .never
            textfield.backgroundColor = UIColor.white
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])//,NSAttributedString.Key.font : UIFon])
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.gray
            }
        }
        searchBar?.placeholder = placeHolder
        searchBar?.sizeToFit()
        searchBar?.delegate = self
        searchBar?.enablesReturnKeyAutomatically = false
    }
    
    func searchForText(_ text: String?) {
        guard let searchHandler = didSearch else { return }
        searchHandler(text ?? "")
    }
}
extension CMDSearchDelegate: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchForText(searchText)
    }
}
