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
    func servicesDidShow(fromViewModel viewModel: OrganizationsShowModels.DropDownList.ViewModel)
    func categoriesDidShow(fromViewModel viewModel: OrganizationsShowModels.DropDownList.ViewModel)
    func organizationsDidShow(fromViewModel viewModel: OrganizationsShowModels.Organizations.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol OrganizationsShowViewControllerOutput {
    func servicesDidLoad(withRequestModel requestModel: OrganizationsShowModels.DropDownList.RequestModel)
    func categoriesDidLoad(withRequestModel requestModel: OrganizationsShowModels.DropDownList.RequestModel)
    func organizationsDidLoad(withRequestModel requestModel: OrganizationsShowModels.Organizations.RequestModel)
}

class OrganizationsShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: OrganizationsShowViewControllerOutput!
    var router: OrganizationsShowRouter!

    var category: Category!
    var tableViewManager            =   ListTableViewController()
    
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet weak var categoriesButton: DropDownButton!
    @IBOutlet weak var servicesButton: DropDownButton!
    @IBOutlet weak var mapButton: CustomButton!
    @IBOutlet weak var dataSourceEmptyView: UIView!

    @IBOutlet weak var tableView: CustomTableView! {
        didSet {
            // Register the Nib header/footer section views
            tableView.register(UINib(nibName: "OrganizationTableViewCell", bundle: nil), forCellReuseIdentifier: "OrganizationCell")
            
            // Delegates
            tableView.dataSource            =   tableViewManager
            tableView.delegate              =   tableViewManager
            tableViewManager.tableView      =   tableView
            tableViewManager.sourceType     =   .Organization
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
        
        smallTopBarView.type                =   "ChildSearch"
        topBarViewStyle                     =   .Small
        setup(topBarView: smallTopBarView)

        viewSettingsDidLoad()
    }
    
    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Set scene title
        smallTopBarView.titleLabel.text     =   category.title
        
        mapButton.isUserInteractionEnabled  =   false
        
        // Handler Back button tap
        smallTopBarView.handlerSendButtonCompletion = { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        // Load organizations
        let organizationsRequestModel = OrganizationsShowModels.Organizations.RequestModel()
        interactor.organizationsDidLoad(withRequestModel: organizationsRequestModel)
        
        // Load services
        let servicesRequestModel = OrganizationsShowModels.DropDownList.RequestModel()
        interactor.servicesDidLoad(withRequestModel: servicesRequestModel)

        // Load categories
        let categoriesRequestModel = OrganizationsShowModels.DropDownList.RequestModel()
        interactor.categoriesDidLoad(withRequestModel: categoriesRequestModel)
    }
    
    
    // MARK: - Actions
    @IBAction func handlerMapButtonTap(_ sender: CustomButton) {
        if (tableViewManager.dataSource.count > 0) {
            router.navigateToOrganizationsMapShowScene(withOrganizations: (tableViewManager.dataSource as! [Organization]))
        }
    }
    
    @IBAction func handlerDropDownButtonTap(_ sender: DropDownButton) {
        (sender.isDropDownListShow) ? sender.itemsListDidHide(inView: view) : sender.itemsListDidShow(inView: view)
        (sender.dropDownTableVC.tableView as! CustomTableView).setScrollIndicatorColor(color: UIColor.veryLightOrange)
        
        // Handler DropDownList selection
        sender.dropDownTableVC.completionHandler = ({ selectedObject in
            sender.changeTitle(newValue: selectedObject.name)
            
            sender.itemsListDidHide(inView: self.view)
        })
    }

    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        categoriesButton.setNeedsDisplay()
        servicesButton.setNeedsDisplay()
        _ = tableView.visibleCells.map{ ($0 as! BaseTableViewCell).dottedBorderView.setNeedsDisplay() }
    }
}


// MARK: - OrganizationsShowViewControllerInput
extension OrganizationsShowViewController: OrganizationsShowViewControllerInput {
    func servicesDidShow(fromViewModel viewModel: OrganizationsShowModels.DropDownList.ViewModel) {
        servicesButton.dataSource                   =   viewModel.dropDownList
    }
    
    func categoriesDidShow(fromViewModel viewModel: OrganizationsShowModels.DropDownList.ViewModel) {
        categoriesButton.dataSource                 =   viewModel.dropDownList
    }

    func organizationsDidShow(fromViewModel viewModel: OrganizationsShowModels.Organizations.ViewModel) {
        self.tableViewManager.dataSource            =   viewModel.organizations
        self.mapButton.isUserInteractionEnabled     =   true
        dataSourceEmptyView.isHidden                =   (viewModel.organizations.count == 0) ? false : true

        self.tableView.reloadData()
    }
}
