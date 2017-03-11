//
//  NewsShowViewController.swift
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
protocol NewsShowViewControllerInput {
    func newsDidShow(fromViewModel viewModel: NewsShowModels.NewsItems.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol NewsShowViewControllerOutput {
    func newsDidLoad(withRequestModel requestModel: NewsShowModels.NewsItems.RequestModel)
}

class NewsShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: NewsShowViewControllerOutput!
    var router: NewsShowRouter!
    
    @IBOutlet weak var copyrightLabel: CustomLabel!
    @IBOutlet weak var dataSourceEmptyView: UIView!
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet weak var segmentedControlView: SegmentedControlView!

    @IBOutlet weak var tableView: MSMTableView! {
        didSet {
            tableView.contentInset              =   UIEdgeInsetsMake((UIApplication.shared.statusBarOrientation.isPortrait) ? 5 : 45, 0, 0, 0)
            tableView.scrollIndicatorInsets     =   UIEdgeInsetsMake((UIApplication.shared.statusBarOrientation.isPortrait) ? 5 : 45, 0, 0, 0)
        }
    }

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NewsShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
                
        viewSettingsDidLoad()
    }
    

    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        setupSegmentedControlView()

        // Config smallTopBarView
        navigationBarView       =   smallTopBarView
        smallTopBarView.type    =   "ParentSearch"
        haveMenuItem            =   true
        
        // Load data
        let requestModel        =   NewsShowModels.NewsItems.RequestModel()
        interactor.newsDidLoad(withRequestModel: requestModel)
    }
    
    func setupSegmentedControlView() {
        segmentedControlView.actionButtonHandlerCompletion = { sender in
//            self.print(object: "\(type(of: self)): \(#function) run. Sender tag = \(sender.tag)")
        }
    }
    
    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(object: "\(type(of: self)): \(#function) run. New size = \(size)")
        
        smallTopBarView.setNeedsDisplay()
        smallTopBarView.circleView.setNeedsDisplay()
        segmentedControlView.setNeedsDisplay()

        tableView.contentInset              =   UIEdgeInsetsMake((size.height > size.width) ? 5 : 65, 0, 0, 0)
        tableView.scrollIndicatorInsets     =   UIEdgeInsetsMake((size.height > size.width) ? 5 : 65, 0, 0, 0)
        
        _ = tableView.visibleCells.map{ ($0 as! NewsTableViewCell).dottedBorderView.setNeedsDisplay() }
    }
}


// MARK: - NewsShowViewControllerInput
extension NewsShowViewController: NewsShowViewControllerInput {
    func newsDidShow(fromViewModel viewModel: NewsShowModels.NewsItems.ViewModel) {
        guard (viewModel.news?.first?.count)! > 0 else {
            dataSourceEmptyView.isHidden    =   false
            tableView.isScrollEnabled       =   false

            return
        }
        
        // TableViewController Manager
        tableView.tableViewControllerManager                    =   MSMTableViewControllerManager()
        tableView.tableViewControllerManager?.tableView         =   self.tableView
        tableView.tableViewControllerManager?.sectionsCount     =   1
        
        // Search Manager
        smallTopBarView.searchBar.placeholder                   =   "Enter Organization name".localized()
        smallTopBarView.searchBar.delegate                      =   tableView.tableViewControllerManager
        
        // Handler select cell
        tableView.tableViewControllerManager!.handlerSearchCompletion           =   { news in
            // TODO: ADD TRANSITION TO CHAT SCENE
            self.print(object: "transition to Chat scene")
            
            //                self.router.navigateToOrganizationShowScene(organization as! Organization)
        }
        
        // Handler Search keyboard button tap
        tableView.tableViewControllerManager!.handlerSendButtonCompletion       =   { _ in
            // TODO: - ADD SEARCH API
            self.smallTopBarView.searchBarDidHide()
        }
        
        // Handler Search Bar Cancel button tap
        tableView.tableViewControllerManager!.handlerCancelButtonCompletion     =   { _ in
            self.smallTopBarView.searchBarDidHide()
        }
        
        
        //            // Handler select cell
        //            tableView.tableViewControllerManager.completionHandler    =   { organization in
        //                // TODO: ADD TRANSITION TO NEWS PROFILE
        //                self.print(object: "transition to News profile scene")
        //            }

        tableView.tableViewControllerManager!.dataSource        =   viewModel.news!.first!
        dataSourceEmptyView.isHidden        =   true
        tableView.isScrollEnabled           =   true

        self.tableView.reloadData()
    }
}
