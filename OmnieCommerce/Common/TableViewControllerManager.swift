//
//  TableViewControllerManager.swift
//  OmnieCommerce
//
//  Created by msm72 on 03.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class TableViewControllerManager: BaseViewController {
    // MARK: - Properties
    var sectionsCount               =   0
    var dataSource                  =   [Any]()
    var dataSourceFiltered          =   [Any]()
    var isSearchBarActive: Bool     =   false
    
    var sourceType: CellStyle!
    var completionHandler: ((_ value: Any) -> ())?
    var tableView: CustomTableView!
    
    var handlerSendButtonCompletion: HandlerSendButtonCompletion?
    var handlerCancelButtonCompletion: HandlerCancelButtonCompletion?
    
    // Register the Nib header/footer section views
    var cellIdentifiers: [(cellXibName: String, cellClassName: AnyClass)]? {
        didSet {
            for identifier in cellIdentifiers! {
                tableView.register(UINib(nibName: identifier.cellXibName, bundle: nil), forCellReuseIdentifier: identifier.cellXibName)
            }
        }
    }
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print(object: "\(type(of: self)) deinit")
    }
}


// MARK: - UITableViewDataSource
extension TableViewControllerManager: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.setScrollIndicatorColor(color: UIColor.veryLightOrange)
        
        return (isSearchBarActive) ? dataSourceFiltered.count : dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = sourceType.rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BaseTableViewCell
        let item = (isSearchBarActive) ? dataSourceFiltered[indexPath.row] : dataSource[indexPath.row]
        
        // Config cell
        cell.setup(withItem: item, andIndexPath: indexPath)
        
        // Handler Favorite button tap
        cell.handlerFavoriteButtonCompletion = { _ in
            // TODO: ADD API TO ADD/REMOVE ITEM TO/FROM FAVORITE LIST
            self.print(object: "favorite button tapped")
        }
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension TableViewControllerManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        completionHandler!((isSearchBarActive) ? dataSourceFiltered[indexPath.row] : dataSource[indexPath.row])
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 96.0
//    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.contentView.backgroundColor = .veryDarkGrayishBlue38
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.contentView.backgroundColor = .clear
    }
}


// MARK: - UISearchBarDelegate
extension TableViewControllerManager: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: - ADD API TO SEARCH ORGANIZATIONS
        handlerSendButtonCompletion!()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchBarActive   =   false
        searchBar.text      =   nil
        
        handlerCancelButtonCompletion!()
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchBarActive   =   true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearchBarActive   =   false
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        isSearchBarActive   =   false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataSourceFiltered  =   (searchText.isEmpty) ? dataSource : dataSource.filter{ ($0 as! SearchObject).name.contains(searchBar.text!) }
        
        tableView.reloadData()
    }
}
