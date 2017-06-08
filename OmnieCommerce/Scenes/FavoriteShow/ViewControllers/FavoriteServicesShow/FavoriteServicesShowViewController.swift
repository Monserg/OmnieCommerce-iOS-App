//
//  FavoriteServicesShowViewController.swift
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
protocol FavoriteServicesShowViewControllerInput {
    func favoriteServicesDidShowLoad(fromViewModel viewModel: FavoriteServicesShowModels.Services.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol FavoriteServicesShowViewControllerOutput {
    func favoriteServicesDidLoad(withRequestModel requestModel: FavoriteServicesShowModels.Services.RequestModel)
}

class FavoriteServicesShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: FavoriteServicesShowViewControllerOutput!
    var router: FavoriteServicesShowRouter!
    
    var services = [Service]()
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
        
        FavoriteServicesShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create MSMTableViewControllerManager
        let servicesTableManager = MSMTableViewControllerManager.init(withTableView: self.tableView,
                                                                      andSectionsCount: 1,
                                                                      andEmptyMessageText: "Services list is empty")
        
        tableView.tableViewControllerManager = servicesTableManager
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        limit = (services.count == 0) ? Config.Constants.paginationLimit : services.count
        viewSettingsDidLoad()
    }


    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Load Services list from Core Data
        guard isNetworkAvailable else {
            favoriteServicesListDidShow()
            return
        }
        
        // Load Services list from API
        if (isNetworkAvailable) {
            services = [Service]()
            CoreDataManager.instance.entitiesDidRemove(byName: "Lists", andPredicateParameters: NSPredicate(format: "name == %@", keyFavoriteServices))
            favoriteServicesListDidLoad(withOffset: 0, scrollingData: false)
        } else {
            spinnerDidFinish()
        }
    }
    
    func favoriteServicesListDidLoad(withOffset offset: Int, scrollingData: Bool) {
        if (!scrollingData) {
            spinnerDidStart(view)
        }
        
        let bodyParameters: [String: Any] = [ "limit": limit, "offset": offset ]
        let servicesRequestModel = FavoriteServicesShowModels.Services.RequestModel(parameters: bodyParameters)
        interactor.favoriteServicesDidLoad(withRequestModel: servicesRequestModel)
    }
    
    func favoriteServicesListDidShow() {
        // Setting MSMTableViewControllerManager
        let servicesList = CoreDataManager.instance.entitiesDidLoad(byName: "Service",
                                                                    andPredicateParameters: NSPredicate(format: "ANY lists.name == %@", keyFavoriteServices))
        
        if let services = servicesList as? [Service] {
            let _ = services.map({ $0.cellIdentifier = "FavoriteServiceTableViewCell"; $0.cellHeight = 60.0 })
            self.services = services
            
            tableView.tableViewControllerManager!.dataSource = services
            tableView!.tableFooterView!.isHidden = (services.count > 0) ? true : false
            
            (tableView!.tableFooterView as! MSMTableViewFooterView).didUpload(forItemsCount: services.count,
                                                                              andEmptyText: "Services list is empty")
            
            tableView.reloadData()
        }
        
        // Handler select cell
        tableView.tableViewControllerManager!.handlerSelectRowCompletion = { service in
            self.router.navigateToServiceShowScene(withServiceID: (service as! Service).codeID)
        }
        
        // Handler PullRefresh
        tableView.tableViewControllerManager!.handlerPullRefreshCompletion = { _ in
            // Reload Services list from API
            self.services = [Service]()
            CoreDataManager.instance.entitiesDidRemove(byName: "Lists", andPredicateParameters: NSPredicate(format: "name == %@", keyFavoriteServices))
            self.limit = Config.Constants.paginationLimit
            self.favoriteServicesListDidLoad(withOffset: 0, scrollingData: true)
        }
        
        // Handler InfiniteScroll
        tableView.tableViewControllerManager.handlerInfiniteScrollCompletion = { _ in
            // Load More Services from API
            self.favoriteServicesListDidLoad(withOffset: self.services.count, scrollingData: true)
        }
        
        tableView.tableViewControllerManager.pullRefreshDidFinish()
        spinnerDidFinish()
    }
}


// MARK: - FavoriteServicesShowViewControllerInput
extension FavoriteServicesShowViewController: FavoriteServicesShowViewControllerInput {
    func favoriteServicesDidShowLoad(fromViewModel viewModel: FavoriteServicesShowModels.Services.ViewModel) {
        // Check for errors
        guard viewModel.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: {
                self.favoriteServicesListDidShow()
            })
            
            return
        }
        
        self.favoriteServicesListDidShow()
    }
}
