//
//  MessagesShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 09.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol MessagesShowViewControllerInput {
    func messagesDidShow(fromViewModel viewModel: MessagesShowModels.Messages.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol MessagesShowViewControllerOutput {
    func messagesDidLoad(withRequestModel requestModel: MessagesShowModels.Messages.RequestModel)
}

class MessagesShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: MessagesShowViewControllerOutput!
    var router:     MessagesShowRouter!
    
    @IBOutlet weak var copyrightLabel: CustomLabel!
    @IBOutlet weak var smallTopBarView: SmallTopBarView!

    @IBOutlet weak var tableView: MSMTableView! {
        didSet {
            smallTopBarView.searchBar.placeholder = "Enter Organization name".localized()
            tableView.contentInset = UIEdgeInsetsMake((UIApplication.shared.statusBarOrientation.isPortrait) ? 5 : 45, 0, 0, 0)
            tableView.scrollIndicatorInsets = UIEdgeInsetsMake((UIApplication.shared.statusBarOrientation.isPortrait) ? 5 : 45, 0, 0, 0)
        }
    }

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        MessagesShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSettingsDidLoad()
    }
    
    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // TableViewController Manager
        let messagesTableManager = MSMTableViewControllerManager.init(withTableView: self.tableView, andSectionsCount: 1, andEmptyMessageText: "Messages list is empty")
        tableView.tableViewControllerManager = messagesTableManager

        // Config smallTopBarView
        navigationBarView       =   smallTopBarView
        smallTopBarView.type    =   "ParentSearch"
        haveMenuItem            =   true
        
        // Load data
        let requestModel = MessagesShowModels.Messages.RequestModel()
        interactor.messagesDidLoad(withRequestModel: requestModel)
    }
    
    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        smallTopBarView.setNeedsDisplay()
        smallTopBarView.circleView.setNeedsDisplay()
        tableView.contentInset = UIEdgeInsetsMake((size.height > size.width) ? 5 : 65, 0, 0, 0)
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake((size.height > size.width) ? 5 : 65, 0, 0, 0)

        _ = tableView.visibleCells.map{ ($0 as! MessageTableViewCell).dottedBorderView.setNeedsDisplay() }
    }
}


// MARK: - MessagesShowViewControllerInput
extension MessagesShowViewController: MessagesShowViewControllerInput {
    func messagesDidShow(fromViewModel viewModel: MessagesShowModels.Messages.ViewModel) {
        guard viewModel.messages != nil else {
//            self.dataSourceEmptyView.isHidden = false
            self.tableView.isScrollEnabled = false

            return
        }
        
        // TableViewController Manager
        tableView.tableViewControllerManager!.dataSource = viewModel.messages!
//        dataSourceEmptyView.isHidden = true
        self.tableView.isScrollEnabled = true
        
        self.tableView.reloadData()
        
        // Search Manager
        smallTopBarView.searchBar.placeholder = "Enter Organization name".localized()
        smallTopBarView.searchBar.delegate = tableView.tableViewControllerManager
        
        // Handler select cell
        tableView.tableViewControllerManager!.handlerSelectRowCompletion = { message in
            // TODO: ADD TRANSITION TO CHAT SCENE
            self.print(object: "transition to Chat scene")
            
            //                self.router.navigateToOrganizationShowScene(organization as! Organization)
        }
        
        // Handler Search keyboard button tap
        tableView.tableViewControllerManager!.handlerSendButtonCompletion = { _ in
            // TODO: - ADD SEARCH API
            self.smallTopBarView.searchBarDidHide()
        }
        
        // Handler Search Bar Cancel button tap
        tableView.tableViewControllerManager!.handlerCancelButtonCompletion = { _ in
            self.smallTopBarView.searchBarDidHide()
        }
        
        
        //            // Handler select cell
        //            tableViewManager.completionHandler = { organization in
        //                // TODO: ADD TRANSITION TO CHAT
        //                self.print(object: "transition to Chat scene")
        //            }
    }
}
