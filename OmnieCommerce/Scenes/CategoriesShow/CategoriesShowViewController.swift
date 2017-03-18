//
//  CategoriesShowViewController.swift
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
protocol CategoriesShowViewControllerInput {
    func categoriesDidShowLoad(fromViewModel viewModel: CategoriesShowModels.Categories.ViewModel)
    func citiesDidShowLoad(fromViewModel viewModel: CategoriesShowModels.Cities.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol CategoriesShowViewControllerOutput {
    func categoriesDidLoad(withRequestModel requestModel: CategoriesShowModels.Categories.RequestModel)
    func citiesDidLoad(withRequestModel requestModel: CategoriesShowModels.Cities.RequestModel)
}

class CategoriesShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: CategoriesShowViewControllerOutput!
    var router: CategoriesShowRouter!
    
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var copyrightLabel: CustomLabel!
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet weak var dataSourceEmptyView: UIView!
    
    @IBOutlet weak var cityButton: DropDownButton!
    
    @IBOutlet weak var collectionView: MSMCollectionView! {
        didSet {
            collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CategoriesShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSettingsDidLoad()
    }
    
    
    // MARK: - Actions
    @IBAction func handlerCityButtonTap(_ sender: DropDownButton) {
        print(object: "\(type(of: self)): \(#function) run.")
        
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
        smallTopBarView.setNeedsDisplay()
        smallTopBarView.circleView.setNeedsDisplay()
        cityButton.setNeedsDisplay()
        
        if (cityButton.isDropDownListShow) {
            cityButton.itemsListDidHide(inView: view)
        }
        
        collectionView.reloadData()
    }
    
    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // Config topBarView
        navigationBarView = smallTopBarView
        smallTopBarView.type = "Parent"
        haveMenuItem = true
        
        // Load Categories list
        spinnerDidStart()
        let categoriesRequestModel = CategoriesShowModels.Categories.RequestModel()
        interactor.categoriesDidLoad(withRequestModel: categoriesRequestModel)
        
        // Load Cities list
        // TODO: UNCOMMENT WHEN NEED TO USE FILTER BY CITIES !!!
//        let citiesRequestModel = CategoriesShowModels.Cities.RequestModel(listType: .City)
//        interactor.citiesDidLoad(withRequestModel: citiesRequestModel)
    }

    func categoriesDidShow(_ categories: [Category], fromAPI isDataFromAPI: Bool) {
        // Setting MSMCollectionViewControllerManager
        collectionView.collectionViewControllerManager = MSMCollectionViewControllerManager(withCollectionView: self.collectionView)
        collectionView.collectionViewControllerManager!.sectionsCount = 1
        collectionView.collectionViewControllerManager!.dataSource = categories
        dataSourceEmptyView.isHidden = (categories.count == 0) ? false : true
        
        collectionView.reloadData()
        
        // Save new data to CoreData
        if (isDataFromAPI) {
            let categoriesData = NSKeyedArchiver.archivedData(withRootObject: categories) as NSData?
            
            guard categoriesData != nil else {
                return
            }
            
            let entityCategories = CoreDataManager.instance.entityDidLoad(byName: keyCategories) as! Categories
            entityCategories.list = categoriesData!
            CoreDataManager.instance.didSaveContext()
        }
    }
}


// MARK: - CategoriesShowViewControllerInput
extension CategoriesShowViewController: CategoriesShowViewControllerInput {
    func categoriesDidShowLoad(fromViewModel viewModel: CategoriesShowModels.Categories.ViewModel) {
        spinnerDidFinish()
        
        guard isNetworkAvailable else {
            alertViewDidShow(withTitle: "Not Reachable".localized(), andMessage: "Disconnected from Network".localized())

            // Show categories list from CoreData
            let categoriesData = CoreDataManager.instance.entityDidLoad(byName: keyCategories) as! Categories
            let categories = NSKeyedUnarchiver.unarchiveObject(with: categoriesData.list as! Data) as! Array<Category>

            self.categoriesDidShow(categories, fromAPI: false)
            return
        }        
        
        // Show categories list from API
        let categories = viewModel.categories!
        self.categoriesDidShow(categories, fromAPI: true)
    }
    
    func citiesDidShowLoad(fromViewModel viewModel: CategoriesShowModels.Cities.ViewModel) {
        cityButton.dataSource = viewModel.list
    }
}
