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
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Custom Functions
    func tableViewDidUpdate(_ organizations: [Organization]?) {
        
        //            // Handler select cell
        //            tableView.tableViewControllerManager.completionHandler    =   { organization in
        //                // TODO: ADD TRANSITION TO NEWS PROFILE
        //                self.print(object: "transition to News profile scene")
        //            }
    }
    
    func viewSettingsDidLoad() {
        tableView.tableViewControllerManager.sectionsCount  =   1
        tableView.tableViewControllerManager.dataSource     =   organizations
        
        dataSourceEmptyView.isHidden                        =   (organizations == nil) ? false : true
        tableView.isScrollEnabled                           =   (organizations == nil) ? false : true
        tableView.tableViewControllerManager.tableView      =   tableView
        
        tableView.reloadData()
    }
    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        _ = tableView.visibleCells.map{ ($0 as! UserTemplateTableViewCell).dottedBorderView.setNeedsDisplay() }
    }
}
