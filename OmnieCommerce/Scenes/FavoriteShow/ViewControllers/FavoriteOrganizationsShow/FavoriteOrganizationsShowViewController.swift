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
    var limit: Int!
    
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
        
        // Create MSMTableViewControllerManager
        let organizationsTableManager = MSMTableViewControllerManager.init(withTableView: self.tableView, andSectionsCount: 1, andEmptyMessageText: "Organizations list is empty")
        tableView.tableViewControllerManager = organizationsTableManager
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        limit = (organizations.count == 0) ? Config.Constants.paginationLimit : organizations.count
        viewSettingsDidLoad()
    }

    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Load Organizations list from Core Data
        guard isNetworkAvailable else {
            favoriteOrganizationsListDidShow()
            return
        }
        
        // Load Organizations list from API
        if (isNetworkAvailable) {
            organizations = [Organization]()
            CoreDataManager.instance.entitiesDidRemove(byName: "Organization", andPredicateParameter: keyFavoriteOrganizations)
            favoriteOrganizationsListDidLoad(withOffset: 0, scrollingData: false)
        } else {
            spinnerDidFinish()
        }
    }
    
    func favoriteOrganizationsListDidLoad(withOffset offset: Int, scrollingData: Bool) {
        if (!scrollingData) {
            spinnerDidStart(view)
        }
        
        let bodyParameters: [String: Any] = [ "limit": limit, "offset": offset ]
        let organizationsRequestModel = FavoriteOrganizationsShowModels.Organizations.RequestModel(parameters: bodyParameters)
        interactor.favoriteOrganizationsDidLoad(withRequestModel: organizationsRequestModel)
    }
    
    func favoriteOrganizationsListDidShow() {
        // Setting MSMTableViewControllerManager
        let organizationsList = CoreDataManager.instance.entitiesDidLoad(byName: "Organization", andPredicateParameter: ["catalog": keyFavoriteOrganizations])
        
        if let organizations = organizationsList as? [Organization] {
            let _ = organizations.map({ $0.cellIdentifier = "FavoriteOrganizationTableViewCell"; $0.cellHeight = 60.0 })
            self.organizations = organizations
            
            tableView.tableViewControllerManager!.dataSource = organizations
            tableView!.tableFooterView!.isHidden = (organizations.count > 0) ? true : false
           
            (tableView!.tableFooterView as! MSMTableViewFooterView).didUpload(forItemsCount: organizations.count,
                                                                              andEmptyText: "Organizations list is empty")
            
            tableView.reloadData()
        }
        
        // Handler select cell
        tableView.tableViewControllerManager!.handlerSelectRowCompletion = { organization in
            self.router.navigateToOrganizationShowScene(organization as! Organization)
        }
        
        // Handler PullRefresh
        tableView.tableViewControllerManager!.handlerPullRefreshCompletion = { _ in
            // Reload Organizations list from API
            self.organizations = [Organization]()
            CoreDataManager.instance.entitiesDidRemove(byName: "Organization", andPredicateParameter: keyFavoriteOrganizations)
            self.limit = Config.Constants.paginationLimit
            self.favoriteOrganizationsListDidLoad(withOffset: 0, scrollingData: true)
        }
        
        // Handler InfiniteScroll
        tableView.tableViewControllerManager.handlerInfiniteScrollCompletion = { _ in
            // Load More Organizations from API
            self.favoriteOrganizationsListDidLoad(withOffset: self.organizations.count, scrollingData: true)
        }
        
        tableView.tableViewControllerManager.pullRefreshDidFinish()
        spinnerDidFinish()
    }
}


// MARK: - FavoriteOrganizationsShowViewControllerInput
extension FavoriteOrganizationsShowViewController: FavoriteOrganizationsShowViewControllerInput {
    func favoriteOrganizationsDidShowLoad(fromViewModel viewModel: FavoriteOrganizationsShowModels.Organizations.ViewModel) {
        // Check for errors
        guard viewModel.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: {
                self.favoriteOrganizationsListDidShow()
            })

            return
        }
        
        self.favoriteOrganizationsListDidShow()
    }
}
