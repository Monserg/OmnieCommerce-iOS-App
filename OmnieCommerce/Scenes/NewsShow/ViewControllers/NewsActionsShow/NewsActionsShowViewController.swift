//
//  NewsActionsShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 31.03.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol NewsActionsShowViewControllerInput {
    func actionsDidShowLoad(fromViewModel viewModel: NewsActionsShowModels.Actions.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol NewsActionsShowViewControllerOutput {
    func actionsDidLoad(withRequestModel requestModel: NewsActionsShowModels.Actions.RequestModel)
}

class NewsActionsShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: NewsActionsShowViewControllerOutput!
    var router: NewsActionsShowRouter!

    var actions = [NewsData]()
    var wasLaunchedAPI = false
    
    @IBOutlet weak var tableView: MSMTableView! {
        didSet {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    
    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NewsActionsShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if (!wasLaunchedAPI) {
            viewSettingsDidLoad()
        }
    }
    

    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Create MSMTableViewControllerManager
        let actionsTableManager = MSMTableViewControllerManager.init(withTableView: self.tableView, andSectionsCount: 1, andEmptyMessageText: "NewsActions list is empty")
        tableView.tableViewControllerManager = actionsTableManager
        
        // Load Actions list from Core Data
        guard isNetworkAvailable else {
            actionsListDidShow(nil, fromAPI: false)
            return
        }
        
        // Load Actions list from API
        if (isNetworkAvailable) {
            actions = [NewsData]()
            actionsListDidLoad(withOffset: 0, scrollingData: false)
            wasLaunchedAPI = true
        } else {
            spinnerDidFinish()
        }
    }
    
    func actionsListDidLoad(withOffset offset: Int, scrollingData: Bool) {
        if (!scrollingData) {
            spinnerDidStart(view)
        }
        
        let bodyParameters: [String: Any] = [ "limit": Config.Constants.paginationLimit, "offset": offset ]
        let actionsRequestModel = NewsActionsShowModels.Actions.RequestModel(parameters: bodyParameters)
        interactor.actionsDidLoad(withRequestModel: actionsRequestModel)
    }

    func actionsListDidShow(_ actions: [NewsData]?, fromAPI: Bool) {
        var actionsList = [NewsData]()
        
        if (fromAPI) {
            actionsList = actions!
        } else {
            let actionsData = CoreDataManager.instance.entityDidLoad(byName: keyNewsData) as! Actions
            actionsList = NSKeyedUnarchiver.unarchiveObject(with: actionsData.list! as Data) as! [NewsData]
        }
        
        // Setting MSMTableViewControllerManager
        tableView.tableViewControllerManager!.dataSource = actionsList
        tableView!.tableFooterView!.isHidden = (actionsList.count > 0) ? true : false
        (tableView!.tableFooterView as! MSMTableViewFooterView).didUpload(forItemsCount: actionsList.count,
                                                                          andEmptyText: "NewsActions list is empty")
        tableView.reloadData()
        
        // Handler select cell
        tableView.tableViewControllerManager!.handlerSelectRowCompletion = { actions in
            // TODO: - UNCOMMENT
            //            self.router.navigateToServiceShowScene(service as! Service)
        }
        
        // Handler PullRefresh
        tableView.tableViewControllerManager!.handlerPullRefreshCompletion = { _ in
            // Reload Actions list from API
            self.actions = [NewsData]()
            self.actionsListDidLoad(withOffset: 0, scrollingData: true)
        }
        
        // Handler InfiniteScroll
        tableView.tableViewControllerManager.handlerInfiniteScrollCompletion = { _ in
            // Load More NewsData from API
            self.actionsListDidLoad(withOffset: actions!.count, scrollingData: true)
        }
        
        tableView.tableViewControllerManager.pullRefreshDidFinish()
    }
}


// MARK: - NewsActionsShowViewControllerInput
extension NewsActionsShowViewController: NewsActionsShowViewControllerInput {
    func actionsDidShowLoad(fromViewModel viewModel: NewsActionsShowModels.Actions.ViewModel) {
        spinnerDidFinish()
        
        // Check for errors
        guard viewModel.actions != nil else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: {
                self.actionsListDidShow(self.actions, fromAPI: true)
            })
            
            return
        }
        
        // Save Actions list to CoreData
        CoreDataManager.instance.didSaveContext()
        
        // Check network connection
        guard isNetworkAvailable else {
            // Load Actions list from CoreData
            self.actionsListDidShow(nil, fromAPI: false)
            return
        }
        
        // Load NewsData list from API
        self.actions.append(contentsOf: viewModel.actions!)
        self.actionsListDidShow(self.actions, fromAPI: true)
    }
}
