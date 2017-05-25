//
//  DiscountCardsShowViewController.swift
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
protocol DiscountCardsShowViewControllerInput {
    func discountCardsDidShowLoad(fromViewModel viewModel: DiscountCardsShowModels.Items.ViewModel)
}

protocol DiscountCardsShowViewControllerOutput {
    func discountCardsDidLoad(withRequestModel requestModel: DiscountCardsShowModels.Items.RequestModel)
}

class DiscountCardsShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: DiscountCardsShowViewControllerOutput!
    var router: DiscountCardsShowRouter!
    
    var discountCards = [DiscountCard]()
    var limit: Int!

    // Outlets
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet weak var createNewDiscountCardButton: FillColorButton!
    
    @IBOutlet weak var collectionView: MSMCollectionView! {
        didSet {
            collectionView.contentInset = UIEdgeInsetsMake(45, 0, 0, 0)
            collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(10, 0, 0, 0)
        }
    }

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DiscountCardsShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Config smallTopBarView
        navigationBarView = smallTopBarView
        smallTopBarView.type = "Parent"
        haveMenuItem = true
        createNewDiscountCardButton.isEnabled = false
        smallTopBarView.searchButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//
////        if (collectionView.collectionViewControllerManager == nil) {
////            limit = Config.Constants.paginationLimit
////        } else {
////            limit = (collectionView.collectionViewControllerManager.dataSource.count == 0) ?    Config.Constants.paginationLimit :
////                                                                                                collectionView.collectionViewControllerManager.dataSource.count
////        }
////     
        
        limit = (discountCards.count == 0) ? Config.Constants.paginationLimit : discountCards.count
        viewSettingsDidLoad()
    }
    

    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // Load DiscountCards list from Core Data
        guard isNetworkAvailable else {
            self.discountCardsListDidShow()
            
            return
        }
        
        // Load DiscountCards list from API
        discountCards = [DiscountCard]()
        CoreDataManager.instance.entitiesDidRemove(byName: "Lists", andPredicateParameters: NSPredicate(format: "name == %@", keyDiscountCards))
        discountCardsListDidLoad(withOffset: 0, filter: "", scrollingData: false)
    }
    
    func discountCardsListDidLoad(withOffset offset: Int, filter: String, scrollingData: Bool) {
        if (!scrollingData) {
            spinnerDidStart(view)
        }
        
        // from = offset, to = limit
        let parameters: [String: Any] = [ "offset": offset, "limit": limit ]
        
        guard isNetworkAvailable else {
            discountCardsListDidShow()
            return
        }
        
        let discountCardsRequestModel = DiscountCardsShowModels.Items.RequestModel(parameters: parameters)
        interactor.discountCardsDidLoad(withRequestModel: discountCardsRequestModel)
    }

    func discountCardsListDidShow() {
        // Setting MSMTableViewControllerManager
        collectionView.collectionViewControllerManager = MSMCollectionViewControllerManager.init(withCollectionView: collectionView,
                                                                                                 andEmptyMessageText: "DiscountCards list is empty")

        let discountCardsEntities = CoreDataManager.instance.entitiesDidLoad(byName: "DiscountCard",
                                                                             andPredicateParameters: NSPredicate(format: "ANY lists.name == %@", keyDiscountCards))
        
        if let discountCardsList = discountCardsEntities as? [DiscountCard] {
            discountCards = discountCardsList
            
            collectionView.collectionViewControllerManager!.sectionsCount = 1
            collectionView.collectionViewControllerManager!.dataSource = discountCards

            collectionView.reloadData()
        }
        
        // Search Manager
        smallTopBarView.searchBar.placeholder = "Enter Organization name".localized()
        
        // Handler select cell
        collectionView.collectionViewControllerManager!.handlerCellSelectCompletion = { discountCard in
            self.router.navigateToDiscountCardShowScene(withDiscountCard: discountCard as! DiscountCard)
        }
        
        // Handler PullRefresh
        collectionView.collectionViewControllerManager!.handlerPullRefreshCompletion = { _ in
            // Reload DiscountCards list from API
            self.discountCards = [DiscountCard]()
            CoreDataManager.instance.entitiesDidRemove(byName: "Lists", andPredicateParameters: NSPredicate(format: "name == %@", keyDiscountCards))
            self.limit = Config.Constants.paginationLimit
            self.discountCardsListDidLoad(withOffset: 0, filter: "", scrollingData: true)
        }
        
        // Handler InfiniteScroll
        collectionView.collectionViewControllerManager.handlerInfiniteScrollCompletion = { _ in
            // Load More DiscountCards from API
            self.discountCardsListDidLoad(withOffset: self.discountCards.count, filter: "", scrollingData: true)
        }
        
        collectionView.collectionViewControllerManager.pullRefreshDidFinish()
        self.smallTopBarView.searchButton.isHidden = (discountCards.count == 0 || !isNetworkAvailable) ? true : false
        createNewDiscountCardButton.isEnabled = true
        smallTopBarView.searchButton.isEnabled = true
        
        spinnerDidFinish()
    }

    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        smallTopBarView.setNeedsDisplay()
        smallTopBarView.circleView.setNeedsDisplay()
        
        collectionView.setNeedsDisplay()
        collectionView.reloadData()
    }
    
    
    // MARK: - Actions
    @IBAction func handlerCreateNewDiscountCardButtonTap(_ sender: FillColorButton) {
        self.router.navigateToDiscountCardCreateScene(withDiscountCard: nil)
    }
}


// MARK: - DiscountCardsShowViewControllerInput
extension DiscountCardsShowViewController: DiscountCardsShowViewControllerInput {
    func discountCardsDidShowLoad(fromViewModel viewModel: DiscountCardsShowModels.Items.ViewModel) {
        // Check for errors
        guard viewModel.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: { _ in
                self.discountCardsListDidShow()
            })
            
            return
        }
        
        self.discountCardsListDidShow()
    }
}
