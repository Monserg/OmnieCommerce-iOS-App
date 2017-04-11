//
//  OrganizationsShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 23.02.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol OrganizationsShowViewControllerInput {
    func organizationsDidShowLoad(fromViewModel viewModel: OrganizationsShowModels.Organizations.ViewModel)
    func servicesDidShowLoad(fromViewModel viewModel: OrganizationsShowModels.Services.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol OrganizationsShowViewControllerOutput {
    func organizationsDidLoad(withRequestModel requestModel: OrganizationsShowModels.Organizations.RequestModel)
    func servicesDidLoad(withRequestModel requestModel: OrganizationsShowModels.Services.RequestModel)
}

class OrganizationsShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: OrganizationsShowViewControllerOutput!
    var router: OrganizationsShowRouter!

    weak var category: Category?
    var organizations = [Organization]()
    var services = [Service]()
    var subcategoryCode: String = ""
    var wasByOrganizationSelected = true
    
    var subcategoriesDropDownTableView: MSMTableView! {
        didSet {
            let subcategoriesTableManager = MSMTableViewControllerManager.init(withTableView: subcategoriesDropDownTableView, andSectionsCount: 1, andEmptyMessageText: "DropDownList")
            subcategoriesDropDownTableView.tableViewControllerManager = subcategoriesTableManager
            subcategoriesDropDownTableView.alpha = 0
           
            subcategoriesDropDownTableView.tableViewControllerManager.dataSource = category!.subcategories!
        }
    }

    var organizationServiceDropDownTableView: MSMTableView! {
        didSet {
            let organizationServiceTableManager = MSMTableViewControllerManager.init(withTableView: organizationServiceDropDownTableView, andSectionsCount: 1, andEmptyMessageText: "DropDownList")
            organizationServiceDropDownTableView.tableViewControllerManager = organizationServiceTableManager
            organizationServiceDropDownTableView.alpha = 0
            
            organizationServiceDropDownTableView.tableViewControllerManager.dataSource =    [
                                                                                                DropDownValue.init(keyOrganization,
                                                                                                                   withName: "By organizations".localized(),
                                                                                                                   andType: .OrganizationService),
                                                                                                DropDownValue.init(keyService,
                                                                                                                   withName: "By services".localized(),
                                                                                                                   andType: .OrganizationService)
                                                                                            ]
        }
    }

    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet weak var mapButton: CustomButton!
    @IBOutlet weak var subcategoriesButton: DropDownButton!
    @IBOutlet weak var organizationServiceButton: DropDownButton!
    
    @IBOutlet weak var tableView: MSMTableView! {
        didSet {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }

    
    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        OrganizationsShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        viewSettingsDidLoad()
    }

    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Create MSMTableViewControllerManager
        let organizationsTableManager = MSMTableViewControllerManager.init(withTableView: tableView, andSectionsCount: 1, andEmptyMessageText: "Organizations list is empty")
        tableView.tableViewControllerManager = organizationsTableManager

        // Config smallTopBarView
        navigationBarView = smallTopBarView
        smallTopBarView.type = "ChildSearch"
        smallTopBarView.titleLabel.text = category!.name!
        haveMenuItem = false
        mapButton.isUserInteractionEnabled = false
        
        // Handler Back button tap
        smallTopBarView.handlerSendButtonCompletion = { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        // Set DropDown lists
        subcategoriesDropDownTableView = MSMTableView(frame: .zero, style: .plain)
        organizationServiceDropDownTableView = MSMTableView(frame: .zero, style: .plain)

        // Load Organizations list from Core Data
        guard isNetworkAvailable else {
            self.organizationsListDidShow(nil, fromAPI: false)
            return
        }
        
        // Load Organizations list from API
        organizations = [Organization]()
        organizationsListDidLoad(withOffset: 0, subCategory: self.subcategoryCode, filter: "", scrollingData: false)
    }
    
    func organizationsListDidLoad(withOffset offset: Int, subCategory: String, filter: String, scrollingData: Bool) {
        if (!scrollingData) {
            spinnerDidStart(view)
        }
        
        let bodyParameters: [String: Any] = [
                                                "category": self.category!.codeID,
                                                "subCategory": subCategory,
                                                "filter": filter,
                                                "limit": Config.Constants.paginationLimit,
                                                "offset": offset
                                            ]

        let organizationsRequestModel = OrganizationsShowModels.Organizations.RequestModel(parameters: bodyParameters, category: category!)
        interactor.organizationsDidLoad(withRequestModel: organizationsRequestModel)
    }
    
    func organizationsListDidShow(_ organizations: [Organization]?, fromAPI: Bool) {
        var organizationsList = [Organization]()
        
        if (fromAPI) {
            organizationsList = organizations!
        } else {
            let organizationsData = CoreDataManager.instance.entityDidLoad(byName: keyOrganizations) as! Organizations
            organizationsList = NSKeyedUnarchiver.unarchiveObject(with: organizationsData.list! as Data) as! [Organization]
        }

        // Setting MSMTableViewControllerManager
        tableView!.tableViewControllerManager!.dataSource = organizationsList
        tableView!.tableFooterView!.isHidden = (organizationsList.count > 0) ? true : false
        smallTopBarView.searchButton.isHidden = (organizationsList.count == 0) ? true : false
        mapButton.isUserInteractionEnabled = true

        (tableView!.tableFooterView as! MSMTableViewFooterView).didUpload(forItemsCount: organizationsList.count,
                                                                          andEmptyText: "Organizations list is empty")
        tableView.reloadData()
        
        // Search Manager
        smallTopBarView.searchBar.placeholder = "Enter Organization name".localized()
        smallTopBarView.searchBar.delegate = tableView.tableViewControllerManager
        
        // Handler select cell
        tableView.tableViewControllerManager!.handlerSelectRowCompletion = { organization in
            self.print(object: "transition to Organization profile scene")
            
            self.router.navigateToOrganizationShowScene(organization as! Organization)
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
            // Reload Organizations list from API
            self.organizations = [Organization]()
            self.organizationsListDidLoad(withOffset: 0, subCategory: self.subcategoryCode, filter: "", scrollingData: true)
        }
        
        // Handler InfiniteScroll
        tableView.tableViewControllerManager.handlerInfiniteScrollCompletion = { _ in
            // Load More Organizations from API
            self.organizationsListDidLoad(withOffset: organizations!.count, subCategory: self.subcategoryCode, filter: "", scrollingData: true)
        }
        
        tableView.tableViewControllerManager.pullRefreshDidFinish()
    }
    
    func servicesListDidLoad(withOffset offset: Int, subCategory: String, filter: String, scrollingData: Bool) {
        if (!scrollingData) {
            spinnerDidStart(view)
        }
        
        let bodyParameters: [String: Any] = [
                                                "category": self.category!.codeID,
                                                "subCategory": subCategory,
                                                "filter": filter,
                                                "limit": Config.Constants.paginationLimit,
                                                "offset": offset
                                            ]
        
        let servicesRequestModel = OrganizationsShowModels.Services.RequestModel(parameters: bodyParameters, category: category!)
        interactor.servicesDidLoad(withRequestModel: servicesRequestModel)
    }
    
    func servicesListDidShow(_ services: [Service]?, fromAPI: Bool) {
        var servicesList = [Service]()
        
        if (fromAPI) {
            servicesList = services!
        } else {
            let servicesData = CoreDataManager.instance.entityDidLoad(byName: keyServices) as! Services
            servicesList = NSKeyedUnarchiver.unarchiveObject(with: servicesData.list! as Data) as! [Service]
        }
        
        // Setting MSMTableViewControllerManager
        tableView!.tableViewControllerManager!.dataSource = servicesList
        tableView!.tableFooterView!.isHidden = (servicesList.count > 0) ? true : false
        smallTopBarView.searchButton.isHidden = (servicesList.count == 0) ? true : false
        mapButton.isUserInteractionEnabled = true
        (tableView!.tableFooterView as! MSMTableViewFooterView).didUpload(forItemsCount: servicesList.count,
                                                                          andEmptyText: "Services list is empty")
        tableView.reloadData()

        // Search Manager
        smallTopBarView.searchBar.placeholder = "Enter Service name".localized()
        smallTopBarView.searchBar.delegate = tableView.tableViewControllerManager
        
        // Handler select cell
        tableView.tableViewControllerManager!.handlerSelectRowCompletion = { service in
            self.print(object: "transition to Service profile scene")
            
            self.router.navigateToServiceShowScene(service as! Service)
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
            // Reload Organizations list from API
            self.services = [Service]()
            self.servicesListDidLoad(withOffset: 0, subCategory: self.subcategoryCode, filter: "", scrollingData: true)
        }
        
        // Handler InfiniteScroll
        tableView.tableViewControllerManager.handlerInfiniteScrollCompletion = { _ in
            // Load More Organizations from API
            self.servicesListDidLoad(withOffset: services!.count, subCategory: self.subcategoryCode, filter: "", scrollingData: true)
        }
        
        tableView.tableViewControllerManager.pullRefreshDidFinish()
    }


    
    // MARK: - Actions
    @IBAction func handlerMapButtonTap(_ sender: CustomButton) {
        if ((tableView.tableViewControllerManager!.dataSource?.count)! > 0) {
            router.navigateToOrganizationsMapShowScene(withItems: (tableView.tableViewControllerManager!.dataSource as! [PointAnnotationBinding]))
        }
    }
    
    @IBAction func handlerSubcategoriesButtonTap(_ sender: DropDownButton) {
        (sender.isDropDownListShow) ?   sender.itemsListDidHide(subcategoriesDropDownTableView, inView: view) :
                                        sender.itemsListDidShow(subcategoriesDropDownTableView, inView: view)

        // Handler DropDownList selection
        subcategoriesDropDownTableView.tableViewControllerManager!.handlerSelectRowCompletion = { subcategory in
            sender.changeTitle(newValue: (subcategory as! DropDownItem).name)
            sender.itemsListDidHide(self.subcategoriesDropDownTableView, inView: self.view)
            self.subcategoryCode = ((subcategory as! DropDownItem).codeID == "All-Subcategories-ID") ? "" : (subcategory as! DropDownItem).codeID
            
            if (self.wasByOrganizationSelected) {
                self.organizations = [Organization]()
                self.organizationsListDidLoad(withOffset: 0, subCategory: self.subcategoryCode, filter: "", scrollingData: false)
            } else {
                self.services = [Service]()
                self.servicesListDidLoad(withOffset: 0, subCategory: self.subcategoryCode, filter: "", scrollingData: false)
            }
        }
        
        if (organizationServiceButton.isDropDownListShow) {
            organizationServiceButton.itemsListDidHide(organizationServiceDropDownTableView, inView: view)
        }
    }
    
    @IBAction func handlerOrganizationServiceButtonTap(_ sender: DropDownButton) {
        (sender.isDropDownListShow) ?   sender.itemsListDidHide(organizationServiceDropDownTableView, inView: view) :
                                        sender.itemsListDidShow(organizationServiceDropDownTableView, inView: view)
        
        // Handler DropDownList selection
        organizationServiceDropDownTableView.tableViewControllerManager!.handlerSelectRowCompletion = { item in
            sender.changeTitle(newValue: (item as! DropDownItem).name)
            sender.itemsListDidHide(self.organizationServiceDropDownTableView, inView: self.view)
            
            if ((item as! DropDownItem).codeID == keyOrganization) {
                self.organizations = [Organization]()
                self.organizationsListDidLoad(withOffset: 0, subCategory: self.subcategoryCode, filter: "", scrollingData: false)
                self.wasByOrganizationSelected = true
            } else {
                self.services = [Service]()
                self.servicesListDidLoad(withOffset: 0, subCategory: self.subcategoryCode, filter: "", scrollingData: false)
                self.wasByOrganizationSelected = false
            }
        }
        
        if (subcategoriesButton.isDropDownListShow) {
            subcategoriesButton.itemsListDidHide(subcategoriesDropDownTableView, inView: view)
        }
    }

    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        smallTopBarView.setNeedsDisplay()
        subcategoriesButton.setNeedsDisplay()
        organizationServiceButton.setNeedsDisplay()
        _ = tableView.visibleCells.map { ($0 as! DottedBorderViewBinding).dottedBorderView.setNeedsDisplay() }
    }
}


// MARK: - OrganizationsShowViewControllerInput
extension OrganizationsShowViewController: OrganizationsShowViewControllerInput {
    func organizationsDidShowLoad(fromViewModel viewModel: OrganizationsShowModels.Organizations.ViewModel) {
        spinnerDidFinish()
        
        // Check for errors
        guard viewModel.organizations != nil else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: { _ in
                self.organizationsListDidShow(self.organizations, fromAPI: true)
            })

            return
        }
        
        // Save Organizations to CoreData
        CoreDataManager.instance.didSaveContext()

        // Check network connection
        guard isNetworkAvailable else {
            // Load Organizations list from CoreData
            self.organizationsListDidShow(nil, fromAPI: false)
            return
        }
        
        // Load Organizations list from API
        self.organizations.append(contentsOf: viewModel.organizations!)
        self.organizationsListDidShow(organizations, fromAPI: true)
    }
    
    func servicesDidShowLoad(fromViewModel viewModel: OrganizationsShowModels.Services.ViewModel) {
        spinnerDidFinish()
        
        // Check for errors
        guard viewModel.services != nil else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: { _ in
                self.servicesListDidShow(self.services, fromAPI: true)
            })
            
            return
        }
        
        // Save Services to CoreData
        CoreDataManager.instance.didSaveContext()
        
        // Check network connection
        guard isNetworkAvailable else {
            // Load Services list from CoreData
            self.servicesListDidShow(nil, fromAPI: false)
            return
        }
        
        // Load Services list from API
        self.services.append(contentsOf: viewModel.services!)
        self.servicesListDidShow(services, fromAPI: true)
    }
}
