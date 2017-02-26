//
//  ListTableViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 26.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class ListTableViewController: UIViewController {
    // MARK: - Properties
    var dataSource = [Any]()
    var sourceType: CellStyle!
    var completionHandler: ((_ value: Any) -> ())?
    var tableView: CustomTableView!
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


// MARK: - UITableViewDataSource
extension ListTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.setScrollIndicatorColor(color: UIColor.veryLightOrange)
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier  =   String()
        
        switch sourceType! {
        case .News:
            cellIdentifier  =   "NewsCell"

        case .Message:
            cellIdentifier  =   "MessageCell"
            
        case .Organization:
            cellIdentifier  =   "OrganizationCell"
            
        default:
            break
        }
        
        let cell            =   tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BaseTableViewCell
        let item            =   dataSource[indexPath.row]
        
        // Config cell
        cell.setup(withItem: item, andIndexPath: indexPath)
        
        // Handler Favorite button tap
        cell.handlerFavoriteButtonCompletion        =   { _ in
            // TODO: ADD API TO ADD/REMOVE ITEM TO/FROM FAVORITE LIST
            print("favorite button tapped")
        }
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension ListTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        completionHandler!(dataSource[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96.0
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell                                        =   tableView.cellForRow(at: indexPath)!
        cell.contentView.backgroundColor                =   .veryDarkGrayishBlue38
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell                                        =   tableView.cellForRow(at: indexPath)!
        cell.contentView.backgroundColor                =   .clear
    }
}
