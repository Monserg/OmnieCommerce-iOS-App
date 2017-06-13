//
//  BusinessCardsShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input & Output protocols
protocol BusinessCardsShowViewControllerInput {
    func businessCardsDidShowLoad(fromViewModel viewModel: BusinessCardsShowModels.Load.ViewModel)
}

protocol BusinessCardsShowViewControllerOutput {
    func businessCardsDidLoad(withRequestModel requestModel: BusinessCardsShowModels.Load.RequestModel)
}

class BusinessCardsShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: BusinessCardsShowViewControllerOutput!
    var router: BusinessCardsShowRouter!
    
    var businessCards = [BusinessCard]()
    var limit: Int!


    // MARK: - Outlets
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet weak var createNewBusinessCardButton: FillColorButton!
    
    @IBOutlet weak var tableView: MSMTableView! {
        didSet {
            tableView.contentInset = UIEdgeInsetsMake((UIDevice.current.orientation.isPortrait) ? 25.0 : 45.0, 0.0, 0.0, 0.0)
            tableView.scrollIndicatorInsets = UIEdgeInsetsMake(10, 0, 0, 0)
        }
    }

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        BusinessCardsShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create MSMTableViewControllerManager
        let bussinessCardsTableManager = MSMTableViewControllerManager.init(withTableView: tableView,
                                                                            andSectionsCount: 1,
                                                                            andEmptyMessageText: "BusinessCards list is empty")
        
        tableView.tableViewControllerManager = bussinessCardsTableManager
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if (tableView.tableViewControllerManager == nil) {
            limit = Config.Constants.paginationLimit
        } else {
            limit = (tableView.tableViewControllerManager.dataSource.count == 0) ?  Config.Constants.paginationLimit :
                                                                                    tableView.tableViewControllerManager.dataSource.count
        }
        
        viewSettingsDidLoad()
    }


    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Config smallTopBarView
        navigationBarView = smallTopBarView
        smallTopBarView.type = "Parent"
        haveMenuItem = true
        createNewBusinessCardButton.isUserInteractionEnabled = false
        
        // Load BussinessCards list from Core Data
        guard isNetworkAvailable else {
            businessCardsListDidShow()
            return
        }
        
        // Load Organizations list from API
        businessCards = [BusinessCard]()
        CoreDataManager.instance.entitiesDidRemove(byName: "Lists", andPredicateParameters: NSPredicate(format: "name == %@", keyBusinessCards))
        businessCardsListDidLoad(withOffset: 0, filter: "", scrollingData: false)
    }
    
    func businessCardsListDidLoad(withOffset offset: Int, filter: String, scrollingData: Bool) {
        if (!scrollingData) {
            spinnerDidStart(view)
        }
        
        let parameters: [String: Any] = [ "limit": limit, "offset": offset ]
        
        guard isNetworkAvailable else {
            businessCardsListDidShow()
            return
        }
        
        let businessCardsRequestModel = BusinessCardsShowModels.Load.RequestModel(parameters: parameters)
        interactor.businessCardsDidLoad(withRequestModel: businessCardsRequestModel)
    }
    
    func businessCardsListDidShow() {
        // Setting MSMTableViewControllerManager
        let businessCardsEntities = CoreDataManager.instance.entitiesDidLoad(byName: "BusinessCard",
                                                                              andPredicateParameters: NSPredicate(format: "ANY lists.name == %@", keyBusinessCards))
        
        if let businessCardsList = businessCardsEntities as? [BusinessCard] {
            businessCards = businessCardsList
            
            tableView.tableViewControllerManager!.dataSource = businessCards
            tableView!.tableFooterView!.isHidden = (businessCards.count > 0) ? true : false
            
            (tableView!.tableFooterView as! MSMTableViewFooterView).didUpload(forItemsCount: businessCards.count,
                                                                              andEmptyText: "BusinessCards list is empty")
            
            tableView.reloadData()
        }
        
        // Search Manager
        smallTopBarView.searchBar.placeholder = "Enter Organization name".localized()
        smallTopBarView.searchBar.delegate = tableView.tableViewControllerManager
        
        // Handler select cell
        tableView.tableViewControllerManager!.handlerSelectRowCompletion = { businessCard in
            self.router.navigateToBusinessCardShowScene(withBusinessCardID: (businessCard as! BusinessCard).codeID)
        }
        
        // Handler Search keyboard button tap
        tableView.tableViewControllerManager!.handlerSendButtonCompletion = { _ in
            self.smallTopBarView.searchBarDidHide()
        }
        
        // Handler Search Bar Cancel button tap
        tableView.tableViewControllerManager!.handlerCancelButtonCompletion = { _ in
            self.smallTopBarView.searchBarDidHide()
        }
        
        // Handler PullRefresh
        tableView.tableViewControllerManager!.handlerPullRefreshCompletion = { _ in
            // Reload Organizations list from API
            self.businessCards = [BusinessCard]()
            CoreDataManager.instance.entitiesDidRemove(byName: "Lists", andPredicateParameters: NSPredicate(format: "name == %@", keyBusinessCards))
            self.limit = Config.Constants.paginationLimit
            self.businessCardsListDidLoad(withOffset: 0, filter: "", scrollingData: true)
        }
        
        // Handler InfiniteScroll
        tableView.tableViewControllerManager.handlerInfiniteScrollCompletion = { _ in
            // Load More Organizations from API
            self.businessCardsListDidLoad(withOffset: self.businessCards.count, filter: "", scrollingData: true)
        }
        
        tableView.tableViewControllerManager.pullRefreshDidFinish()
        createNewBusinessCardButton.isUserInteractionEnabled = true
        spinnerDidFinish()
    }

    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        smallTopBarView.setNeedsDisplay()
        smallTopBarView.circleView.setNeedsDisplay()

        _ = tableView.visibleCells.map{ ($0 as! DottedBorderViewBinding).dottedBorderView.setNeedsDisplay() }
        
        tableView.contentInset = UIEdgeInsetsMake((size.height > size.width) ? 25.0 : 65.0, 0.0, 0.0, 0.0)
    }
    
    
    // MARK: - Actions
    @IBAction func handlerCreateNewBusinessCardButtonTap(_ sender: FillColorButton) {
        self.router.navigateToBusinessCardCreateScene(withBusinessCardID: nil)
    }
}


// MARK: - BusinessCardsShowViewControllerInput
extension BusinessCardsShowViewController: BusinessCardsShowViewControllerInput {
    func businessCardsDidShowLoad(fromViewModel viewModel: BusinessCardsShowModels.Load.ViewModel) {
        // Check for errors
        guard viewModel.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: { _ in
                self.businessCardsListDidShow()
            })
            
            return
        }
        
        self.businessCardsListDidShow()
    }
}
