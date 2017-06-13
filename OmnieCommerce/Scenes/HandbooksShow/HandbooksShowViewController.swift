//
//  HandbooksShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 20.05.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol HandbooksShowViewControllerInput {
    func handbooksDidShowLoad(fromViewModel viewModel: HandbooksShowModels.Items.ViewModel)
    func businessCardDidShowCreateFromHandbook(fromViewModel viewModel: HandbooksShowModels.BusinessCard.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol HandbooksShowViewControllerOutput {
    func handbooksDidLoad(withRequestModel requestModel: HandbooksShowModels.Items.RequestModel)
    func businessCardDidCreateFromHandbook(withRequestModel requestModel: HandbooksShowModels.BusinessCard.RequestModel)
}

class HandbooksShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: HandbooksShowViewControllerOutput!
    var router: HandbooksShowRouter!
    
    var handbooks: [Handbook]!
    var limit: Int!

    // Outlets
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet weak var createNewHandbookButton: FillColorButton!
    @IBOutlet var modalView: ModalView!

    @IBOutlet weak var tableView: MSMTableView! {
        didSet {
            tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0)
            tableView.scrollIndicatorInsets = UIEdgeInsetsMake(10, 0, 0, 0)
        }
    }
    

    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        HandbooksShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Config smallTopBarView
        navigationBarView = smallTopBarView
        smallTopBarView.type = "ParentSearch"
        haveMenuItem = true
        createNewHandbookButton.isEnabled = false
        smallTopBarView.searchButton.isEnabled = false
        
        // Create MSMTableViewControllerManager
        let handbooksTableManager = MSMTableViewControllerManager.init(withTableView: tableView,
                                                                       andSectionsCount: 1,
                                                                       andEmptyMessageText: "Handbooks list is empty")
        
        tableView.tableViewControllerManager = handbooksTableManager
        
        // Handler Phone button tap completion
        handbooksTableManager.handlerTapPhoneButtonCompletion = { phones in
            self.modalViewDidShow(withHeight: 185, customSubview: PhonesView(), andValues: phones as! [String])
        }
    
        // Handler Business Card button tap completion
        handbooksTableManager.handlerTapBussinessCardButtonCompletion = { itemID in
            let businessCardRequestModel = HandbooksShowModels.BusinessCard.RequestModel(parameters: [ "id": itemID as AnyObject ])
            self.interactor.businessCardDidCreateFromHandbook(withRequestModel: businessCardRequestModel)
        }
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
        // Load Organizations list from Core Data
        guard isNetworkAvailable else {
            self.handbooksListDidShow()
            
            return
        }
        
        // Load Organizations list from API
        handbooks = [Handbook]()
        CoreDataManager.instance.entitiesDidRemove(byName: "Lists", andPredicateParameters: NSPredicate(format: "name == %@", keyHandbooks))
        handbooksListDidLoad(withOffset: 0, filter: "", scrollingData: false)
    }
    
    func handbooksListDidLoad(withOffset offset: Int, filter: String, scrollingData: Bool) {
        if (!scrollingData) {
            spinnerDidStart(view)
        }
        
        // from = offset, to = limit
        let parameters: [String: Any] = [
                                            "from": offset,
                                            "to": limit,
                                            "locale": Locale.current.languageCode!.lowercased()
                                        ]
        
        guard isNetworkAvailable else {
            handbooksListDidShow()
            return
        }
        
        let handbooksRequestModel = HandbooksShowModels.Items.RequestModel(parameters: parameters)
        interactor.handbooksDidLoad(withRequestModel: handbooksRequestModel)
    }
    
    func handbooksListDidShow() {
        // Setting MSMTableViewControllerManager
        let handbooksEntities = CoreDataManager.instance.entitiesDidLoad(byName: "Handbook",
                                                                        andPredicateParameters: NSPredicate(format: "ANY lists.name == %@", keyHandbooks))
        
        if let handbooksList = handbooksEntities as? [Handbook] {
            handbooks = handbooksList
            
            tableView.tableViewControllerManager!.dataSource = handbooks
            tableView!.tableFooterView!.isHidden = (handbooks.count > 0) ? true : false
            createNewHandbookButton.isUserInteractionEnabled = (handbooks.count > 0) ? true : false
            
            (tableView!.tableFooterView as! MSMTableViewFooterView).didUpload(forItemsCount: handbooks.count,
                                                                              andEmptyText: "Handbooks list is empty")
            
            tableView.reloadData()
        }
        
        // Search Manager
        smallTopBarView.searchBar.placeholder = "Enter Organization name".localized()
        smallTopBarView.searchBar.delegate = tableView.tableViewControllerManager
        
        // Handler select cell
        tableView.tableViewControllerManager!.handlerSelectRowCompletion = { handbook in
            self.router.navigateToOrganizationShowScene(withOrganizationID: (handbook as! Handbook).codeID)
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
        
        // Handler PullRefresh
        tableView.tableViewControllerManager!.handlerPullRefreshCompletion = { _ in
            // Reload Handbooks list from API
            self.handbooks = [Handbook]()
            CoreDataManager.instance.entitiesDidRemove(byName: "Lists", andPredicateParameters: NSPredicate(format: "name == %@", keyHandbooks))
            self.limit = Config.Constants.paginationLimit
            self.handbooksListDidLoad(withOffset: 0, filter: "", scrollingData: true)
        }
        
        // Handler InfiniteScroll
        tableView.tableViewControllerManager.handlerInfiniteScrollCompletion = { _ in
            // Load More Handbooks from API
            self.handbooksListDidLoad(withOffset: self.handbooks.count, filter: "", scrollingData: true)
        }
        
        tableView.tableViewControllerManager.pullRefreshDidFinish()
        self.smallTopBarView.searchButton.isHidden = (handbooks.count == 0 || !isNetworkAvailable) ? true : false
        createNewHandbookButton.isEnabled = true
        smallTopBarView.searchButton.isEnabled = true

        spinnerDidFinish()
    }

    func modalViewDidShow(withHeight height: CGFloat, customSubview subView: CustomView, andValues values: [Any]?) {
        var popupView = subView
        
        if (blackoutView == nil) {
            blackoutView = MSMBlackoutView.init(inView: view)
            blackoutView!.didShow()
            self.revealViewController().panGestureRecognizer().isEnabled = false
        }
        
        modalView = ModalView.init(inView: blackoutView!, withHeight: height)

        switch subView {
        case subView as PhonesView:
            popupView = PhonesView.init(inView: modalView!)
            popupView.values = values as! [String]
            
            // Handler Phones format error
            (popupView as! PhonesView).handlerPhonesFormatErrorCompletion = { _ in
                self.alertViewDidShow(withTitle: "Error", andMessage: "Wrong phones format", completion: { _ in })
            }

        case subView as ConfirmSaveView:
            popupView = ConfirmSaveView.init(inView: modalView!, withText: "BussinessСard create message")
            
        default:
            break
        }
        
        // Handler Cancel button tap
        popupView.handlerCancelButtonCompletion = { _ in
            self.blackoutView!.didHide()
            self.blackoutView = nil
            self.revealViewController().panGestureRecognizer().isEnabled = true
        }
    }
    
    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        smallTopBarView.setNeedsDisplay()
        smallTopBarView.circleView.setNeedsDisplay()

        _ = tableView.visibleCells.map { ($0 as! DottedBorderViewBinding).dottedBorderView.setNeedsDisplay() }
    }
    
    
    // MARK: - Actions
    @IBAction func handlerCreateNewHandbookButtonTap(_ sender: FillColorButton) {
        self.router.navigateToHandbookShowScene()
    }
}


// MARK: - HandbooksShowViewControllerInput
extension HandbooksShowViewController: HandbooksShowViewControllerInput {
    func handbooksDidShowLoad(fromViewModel viewModel: HandbooksShowModels.Items.ViewModel) {
        // Check for errors
        guard viewModel.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: {
                self.handbooksListDidShow()
            })
            
            return
        }
        
        self.handbooksListDidShow()
    }
    
    func businessCardDidShowCreateFromHandbook(fromViewModel viewModel: HandbooksShowModels.BusinessCard.ViewModel) {
        spinnerDidFinish()
        
        // Check for errors
        guard viewModel.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: {})
            
            return
        }
        
        self.modalViewDidShow(withHeight: 185.0, customSubview: ConfirmSaveView(), andValues: nil)
    }
}
