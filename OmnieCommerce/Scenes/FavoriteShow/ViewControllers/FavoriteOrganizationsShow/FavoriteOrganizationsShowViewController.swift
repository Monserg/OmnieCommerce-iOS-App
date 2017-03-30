//
//  FavoriteOrganizationsShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 28.03.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol FavoriteOrganizationsShowViewControllerInput {
    func favoriteOrganizationsDidShowLoad(fromViewModel viewModel: FavoriteOrganizationsShowModels.Organizations.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol FavoriteOrganizationsShowViewControllerOutput {
    func favoriteOrganizationsDidLoad(withRequestModel requestModel: FavoriteOrganizationsShowModels.Organizations.RequestModel)
}

class FavoriteOrganizationsShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: FavoriteOrganizationsShowViewControllerOutput!
    var router: FavoriteOrganizationsShowRouter!
    
    var organizations = [Organization]()
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
        
        FavoriteOrganizationsShowConfigurator.sharedInstance.configure(viewController: self)
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
        let organizationsTableManager = MSMTableViewControllerManager.init(withTableView: self.tableView, andSectionsCount: 1, andEmptyMessageText: "Organizations list is empty")
        tableView.tableViewControllerManager = organizationsTableManager

        // Load Organizations list from Core Data
        guard isNetworkAvailable else {
            favoriteOrganizationsListDidShow(nil, fromAPI: false)
            return
        }
        
        // Load Organizations list from API
        if (isNetworkAvailable) {
            organizations = [Organization]()
            favoriteOrganizationsListDidLoad(withOffset: 0, scrollingData: false)
            wasLaunchedAPI = true
        } else {
            spinnerDidFinish()
        }
    }
    
    func favoriteOrganizationsListDidLoad(withOffset offset: Int, scrollingData: Bool) {
        if (!scrollingData) {
            spinnerDidStart(view)
        }
        
        let parameters: [String: Int] =     [
                                                "limit": Config.Constants.paginationLimit,
                                                "offset": offset
                                            ]
        
        let organizationsRequestModel = FavoriteOrganizationsShowModels.Organizations.RequestModel(parameters: parameters)
        interactor.favoriteOrganizationsDidLoad(withRequestModel: organizationsRequestModel)
    }
    
    func favoriteOrganizationsListDidShow(_ organizations: [Organization]?, fromAPI: Bool) {
        var organizationsList = [Organization]()
        
        if (fromAPI) {
            organizationsList = organizations!
        } else {
            let organizationsData = CoreDataManager.instance.entityDidLoad(byName: keyFavoriteOrganizations) as! Organizations
            organizationsList = NSKeyedUnarchiver.unarchiveObject(with: organizationsData.list! as Data) as! [Organization]
        }
        
        // Setting MSMTableViewControllerManager
        tableView.tableViewControllerManager!.dataSource = organizationsList
        tableView!.tableFooterView!.isHidden = (organizationsList.count > 0) ? true : false
        (tableView!.tableFooterView as! MSMTableViewFooterView).didUpload(forItemsCount: organizationsList.count,
                                                                          andEmptyText: "Organizations list is empty")
        tableView.reloadData()
        
        // Handler select cell
        tableView.tableViewControllerManager!.handlerSelectRowCompletion = { organization in
            self.router.navigateToOrganizationShowScene(organization as! Organization)
        }
        
        // Handler PullRefresh
        tableView.tableViewControllerManager!.handlerPullRefreshCompletion = { _ in
            // Reload Organizations list from API
            self.organizations = [Organization]()
            self.favoriteOrganizationsListDidLoad(withOffset: 0, scrollingData: true)
        }
        
        // Handler InfiniteScroll
        tableView.tableViewControllerManager.handlerInfiniteScrollCompletion = { _ in
            // Load More Organizations from API
            self.favoriteOrganizationsListDidLoad(withOffset: organizations!.count, scrollingData: true)
        }
        
        tableView.tableViewControllerManager.pullRefreshDidFinish()
    }
}


// MARK: - FavoriteOrganizationsShowViewControllerInput
extension FavoriteOrganizationsShowViewController: FavoriteOrganizationsShowViewControllerInput {
    func favoriteOrganizationsDidShowLoad(fromViewModel viewModel: FavoriteOrganizationsShowModels.Organizations.ViewModel) {
        spinnerDidFinish()
        
        guard viewModel.organizations != nil else {
            self.favoriteOrganizationsListDidShow(organizations, fromAPI: true)
            return
        }
        
        CoreDataManager.instance.didSaveContext()
        
        // Load Organizations list from CoreData
        guard isNetworkAvailable else {
            self.favoriteOrganizationsListDidShow(nil, fromAPI: false)
            return
        }
        
        // Load Organizations list from API
        self.organizations.append(contentsOf: viewModel.organizations!)
        self.favoriteOrganizationsListDidShow(organizations, fromAPI: true)
    }    
}
