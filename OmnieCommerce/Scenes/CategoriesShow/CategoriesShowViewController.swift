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
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol CategoriesShowViewControllerOutput {
    func categoriesDidLoad(withRequestModel requestModel: CategoriesShowModels.Categories.RequestModel)
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
//        print(object: "\(type(of: self)): \(#function) run.")
//        
//        (sender.isDropDownListShow) ? sender.itemsListDidHide(inView: view) : sender.itemsListDidShow(inView: view)
//        (sender.dropDownTableVC.tableView as! CustomTableView).setScrollIndicatorColor(color: UIColor.veryLightOrange)
//        
//        // Handler DropDownList selection
//        sender.dropDownTableVC.completionHandler = ({ selectedObject in
//            sender.changeTitle(newValue: selectedObject.name)
//            
//            sender.itemsListDidHide(inView: self.view)
//        })
    }
    
    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        smallTopBarView.setNeedsDisplay()
        smallTopBarView.circleView.setNeedsDisplay()
//        cityButton.setNeedsDisplay()
//        
//        if (cityButton.isDropDownListShow) {
//            cityButton.itemsListDidHide(inView: view)
//        }
        
        collectionView.reloadData()
    }
    
    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // Config topBarView
        navigationBarView = smallTopBarView
        smallTopBarView.type = "Parent"
        haveMenuItem = true
        
        // Load Categories list from CoreData
        guard isNetworkAvailable else {
            self.categoriesListDidShow(nil, fromAPI: false)
            
            // TODO: - ADD LOAD CITIES LIST FROM COREDATA
            return
        }
        
        // Load Categories list from API
        spinnerDidStart(nil)        
        let categoriesParameters: [String: Any] = [ "locale": Locale.current.regionCode!.lowercased() ]
        let categoriesRequestModel = CategoriesShowModels.Categories.RequestModel(parameters: categoriesParameters)
        interactor.categoriesDidLoad(withRequestModel: categoriesRequestModel)
    }

    func categoriesListDidShow(_ categories: [Category]?, fromAPI: Bool) {
        var categoriesList = [Category]()
        
        if (fromAPI) {
            categoriesList = categories!
        } else {
            let categoriesData = CoreDataManager.instance.entityDidLoad(byName: keyCategories) as! Categories
            categoriesList = NSKeyedUnarchiver.unarchiveObject(with: categoriesData.list! as Data) as! [Category]
        }
        
        // Setting MSMCollectionViewControllerManager
        collectionView.collectionViewControllerManager = MSMCollectionViewControllerManager(withCollectionView: self.collectionView)
        collectionView.collectionViewControllerManager!.sectionsCount = 1
        collectionView.collectionViewControllerManager!.dataSource = categoriesList
        dataSourceEmptyView.isHidden = (categoriesList.count == 0) ? false : true

        collectionView.reloadData()
                
        self.collectionViewCellDidSelect()
    }
    
    private func collectionViewCellDidSelect() {
        collectionView.collectionViewControllerManager!.handlerCellSelectCompletion = { item in
            switch item {
            case (let category as Category):
                // Transition to OrganizationsShow scene with selected Category value
                self.router.navigateToOrganizationsShowScene(withCategory: category)

            default:
                break
            }
        }
    }
}


// MARK: - CategoriesShowViewControllerInput
extension CategoriesShowViewController: CategoriesShowViewControllerInput {
    func categoriesDidShowLoad(fromViewModel viewModel: CategoriesShowModels.Categories.ViewModel) {
        spinnerDidFinish()
        CoreDataManager.instance.didSaveContext()
        
        // Load Categories list from CoreData
        guard isNetworkAvailable else {
            self.categoriesListDidShow(nil, fromAPI: false)
            return
        }        
        
        // Load categories list from API
        let categories = viewModel.categories!
        self.categoriesListDidShow(categories, fromAPI: true)
    }
}
