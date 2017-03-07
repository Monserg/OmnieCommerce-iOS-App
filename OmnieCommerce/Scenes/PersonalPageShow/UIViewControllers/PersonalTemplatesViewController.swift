//
//  PersonalTemplatesViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class PersonalTemplatesViewController: BaseViewController {
    // MARK: - Properties
    var organizations: [Organization]?
    
    @IBOutlet weak var tableView: MSMTableView! {
        didSet {
            tableView.contentInset                  =   UIEdgeInsetsMake(0, 0, 0, 0)
            tableView.scrollIndicatorInsets         =   UIEdgeInsetsMake(0, 0, 0, 0)
            
            // TableViewController Manager
            tableView.tableViewControllerManager    =   MSMTableViewControllerManager()
        }
    }
    
    @IBOutlet weak var dataSourceEmptyView: UIView!

    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSettingsDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        tableView.tableViewControllerManager.sectionsCount  =   1
        tableView.tableViewControllerManager.dataSource     =   organizations
        
        dataSourceEmptyView.isHidden                        =   (organizations == nil) ? false : true
        tableView.isScrollEnabled                           =   (organizations == nil) ? false : true
        tableView.tableViewControllerManager.tableView      =   tableView
        
        tableView.reloadData()
    }
    
}
