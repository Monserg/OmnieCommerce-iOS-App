//
//  MSMTableViewControllerManager.swift
//  OmnieCommerce
//
//  Created by msm72 on 04.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class MSMTableViewControllerManager: BaseViewController {
    // MARK: - Properties
    var sectionsCount               =   0
    var dataSource                  =   [Any]()
    var dataSourceFiltered          =   [Any]()
    var isSearchBarActive: Bool     =   false
    
//    var sourceType: CellStyle!
    var tableView: MSMTableView!
    
    var handlerSearchCompletion: ((_ value: Any) -> ())?
    var handlerSendButtonCompletion: HandlerSendButtonCompletion?
    var handlerCancelButtonCompletion: HandlerCancelButtonCompletion?
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]. UIScrollView.contentOffset.y = \(scrollView.contentOffset.y)")
        
        self.tableView.setScrollIndicatorColor(color: UIColor.veryLightOrange)
    }
}


// MARK: - UITableViewDataSource
extension MSMTableViewControllerManager: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (isSearchBarActive) ? dataSourceFiltered.count : dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier      =   self.tableView.cellIdentifiers![indexPath.row]
        let cell                =   self.tableView.dequeueReusableCell(withIdentifier: String(cellIdentifier), for: indexPath) as! ConfigureCell
        let item                =   (isSearchBarActive) ? dataSourceFiltered[indexPath.row] : dataSource[indexPath.row]
        
        // Config cell
        cell.setup(withItem: item, andIndexPath: indexPath)
        
//        // Handler Favorite button tap
//        cell.handlerFavoriteButtonCompletion    =   { _ in
//            // TODO: ADD API TO ADD/REMOVE ITEM TO/FROM FAVORITE LIST
//            self.print(object: "favorite button tapped")
//        }
        
        return cell as! UITableViewCell
    }
}


// MARK: - UITableViewDelegate
extension MSMTableViewControllerManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        handlerSearchCompletion!((isSearchBarActive) ? dataSourceFiltered[indexPath.row] : dataSource[indexPath.row])
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 96.0
    //    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell                            =   tableView.cellForRow(at: indexPath)!
        cell.contentView.backgroundColor    =   .veryDarkGrayishBlue38
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell                            =   tableView.cellForRow(at: indexPath)!
        cell.contentView.backgroundColor    =   .clear
    }
}



// MARK: - UISearchBarDelegate
extension MSMTableViewControllerManager: UISearchBarDelegate {
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
