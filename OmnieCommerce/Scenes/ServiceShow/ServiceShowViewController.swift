//
//  ServiceShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.04.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import Cosmos
import Kingfisher

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol ServiceShowViewControllerInput {
    func serviceDidShowLoad(fromViewModel viewModel: ServiceShowModels.ServiceItem.ViewModel)
    func orderDidShowLoad(fromViewModel viewModel: ServiceShowModels.OrderItem.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol ServiceShowViewControllerOutput {
    func serviceDidLoad(withRequestModel requestModel: ServiceShowModels.ServiceItem.RequestModel)
    func orderDidLoad(withRequestModel requestModel: ServiceShowModels.OrderItem.RequestModel)
}

class ServiceShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: ServiceShowViewControllerOutput!
    var router: ServiceShowRouter!
    
    var service: Service!
    var orderDateComponents: DateComponents?
    var orderStartTimeComponents: DateComponents?
    var orderEndTimeComponents: DateComponents?
    var wasLaunchedAPI = false

    // Outlets
    @IBOutlet var modalView: ModalView?
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var smallTopBarView: SmallTopBarView!

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    @IBOutlet var dottedBorderViewsCollection: [DottedBorderView]! {
        didSet {
            _ = dottedBorderViewsCollection.map { $0.style = .BottomDottedLine }
        }
    }
    
    // Title view
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var favoriteButton: CustomButton!
    @IBOutlet weak var titleLabel: UbuntuLightVeryLightOrangeLabel!
    @IBOutlet weak var titleViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTableViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var contentLabel: UbuntuLightVeryLightGrayLabel! {
        didSet {
            contentLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var titleTableView: MSMTableView! {
        didSet {
            titleTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }

    // Discounts view
    @IBOutlet weak var discountsView: UIView!
    @IBOutlet weak var discountCommonStackView: UIStackView!
    
    @IBOutlet weak var discountsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var discountCommonTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var discountsUserTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var discountsCommonTableView: MSMTableView! {
        didSet {
            discountsCommonTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            discountsCommonTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    @IBOutlet weak var discountUserStackView: UIStackView!
    
    @IBOutlet weak var discountsUserTableView: MSMTableView!  {
        didSet {
            discountsUserTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            discountsUserTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }

    // Gallery view
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var galleryCollectionView: MSMCollectionView!

    // Additional Services view
    @IBOutlet weak var additionalServicesView: UIView!
    @IBOutlet weak var additionalServicesViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var additionalServicesTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var additionalServicesTableView: MSMTableView! {
        didSet {
            additionalServicesTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            additionalServicesTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }

    // Calendar view
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var calendarButton: UbuntuLightVeryLightOrangeButton!
    @IBOutlet weak var calendarStartTimeButton: UbuntuLightVeryLightOrangeButton!
    @IBOutlet weak var calendarEndTimeButton: UbuntuLightVeryLightOrangeButton!
    
    // Comment view
    @IBOutlet weak var commentTextView: UITextView! {
        didSet {
            commentTextView.delegate = self
            commentTextView.text = commentTextView.text.localized()
            textViewPlaceholderDidUpload(commentTextView.text)
        }
    }
    
    @IBOutlet weak var aroundDottedBorderView: DottedBorderView! {
        didSet {
            aroundDottedBorderView.style = .AroundDottedRectangle
        }
    }
    
    @IBOutlet weak var orderButton: FillVeryLightOrangeButton! {
        didSet {
            // FIXME: - SET DEFAULT = FALSE
            orderButton.isEnabled = true
        }
    }
    
    // Reviews view
    @IBOutlet weak var reviewsView: UIView!
    @IBOutlet weak var reviewsCollectionView: MSMCollectionView!
    
    // Rating view
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var userNameLabel: UbuntuLightVeryLightOrangeLabel!
    @IBOutlet weak var userAvatarImageView: CustomImageView!
    @IBOutlet weak var cosmosView: CosmosView!

    
    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ServiceShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if (blackoutView != nil) {
            modalView?.center = blackoutView!.center
        }
        
//        guard let flowLayout = reviewsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
//            return
//        }
//        
//        flowLayout.itemSize = reviewsCollectionView.frame.size
//        flowLayout.invalidateLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer))
        view.addGestureRecognizer(tapGesture)

        orderDateComponents = Calendar.current.dateComponents([.month, .day, .year, .hour, .minute], from: Date())
        orderStartTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
        orderEndTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: Date().addingTimeInterval(TimeInterval(service.duration / 1_000)))
       
        viewSettingsDidLoad()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.indicatorDidChange(UIColor.veryLightOrange)
    }

    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Config smallTopBarView
        navigationBarView = smallTopBarView
        smallTopBarView.type = "Child"
        smallTopBarView.titleText = service.organizationName ?? "Zorro"
        haveMenuItem = false
        
        // Handler Back button tap
        smallTopBarView.handlerSendButtonCompletion = { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        spinnerDidStart(view)
        wasLaunchedAPI = true
        
        guard isNetworkAvailable else {
            serviceProfileDidShow()
            return
        }
        
        // Load Service profile data
        let serviceRequestModel = ServiceShowModels.ServiceItem.RequestModel(parameters: [ "id": service.codeID, "locale": Locale.current.languageCode!.lowercased() ])
        interactor.serviceDidLoad(withRequestModel: serviceRequestModel)
    }
    
    func serviceProfileDidShow() {
        // Setting Service profile info
        let serviceProfile = CoreDataManager.instance.entityDidLoad(byName: "Service", andPredicateParameter: service.codeID) as! Service
        
        // Title view
        if let contentDescription = serviceProfile.descriptionContent, contentDescription.isEmpty {
            titleView.isHidden = true
        } else {
            titleView.isHidden = false
            
            titleLabel.text = serviceProfile.name
            contentLabel.text = serviceProfile.descriptionContent ?? ""
            contentLabel.sizeToFit()
            
            favoriteButton.tag = (service.isFavorite) ? 1 : 0
            favoriteButton.setImage(UIImage.init(named: (favoriteButton.tag == 0) ? "image-favorite-star-normal" : "image-favorite-star-selected"), for: .normal)

            if ((serviceProfile.prices?.count)! > 0) {
                let titleTableManager = MSMTableViewControllerManager.init(withTableView: titleTableView,
                                                                           andSectionsCount: 1,
                                                                           andEmptyMessageText: "Service prices list is empty")
                
                titleTableView.tableViewControllerManager = titleTableManager
                titleTableView.tableViewControllerManager!.dataSource = Array(serviceProfile.prices!)
                titleTableView.tableFooterView!.isHidden = true
                titleTableViewHeightConstraint.constant = CGFloat(20.0 * Double(serviceProfile.prices!.count)) * view.heightRatio
                titleTableView.layoutIfNeeded()

                titleTableView.reloadData()
            }
            
            view.setNeedsLayout()
        }

        // Discounts view
        if let discounts = serviceProfile.discounts, discounts.count > 0 {
            // Show/Hide Common discounts
            let discountsCommon = CoreDataManager.instance.entitiesDidLoad(byName: "Discount", andPredicateParameter: ["isUserDiscount": false])
            
            if (discountsCommon!.count > 0) {
                discountCommonStackView.isHidden = false
                
                let discountCommonTableManager = MSMTableViewControllerManager.init(withTableView: discountsCommonTableView,
                                                                                    andSectionsCount: 1,
                                                                                    andEmptyMessageText: "Common discounts list is empty")
                
                discountsCommonTableView.tableViewControllerManager = discountCommonTableManager
                discountsCommonTableView.tableViewControllerManager!.dataSource = discountsCommon!
                discountsCommonTableView.tableFooterView!.isHidden = true
                discountCommonTableViewHeightConstraint.constant = CGFloat(50.0 + 50.0 * Double(discountsCommon!.count)) * view.heightRatio
                
                discountsCommonTableView.reloadData()
            } else {
                discountCommonStackView.isHidden = true
            }
            
            // Show/Hide User discounts
            let discountsUser = CoreDataManager.instance.entitiesDidLoad(byName: "Discount", andPredicateParameter: ["isUserDiscount": true])
            
            if (discountsUser!.count > 0) {
                discountUserStackView.isHidden = false
                
                let discountsUserTableManager = MSMTableViewControllerManager.init(withTableView: discountsUserTableView,
                                                                                   andSectionsCount: 1,
                                                                                   andEmptyMessageText: "User discounts list is empty")
                
                discountsUserTableView.tableViewControllerManager = discountsUserTableManager
                discountsUserTableView.tableViewControllerManager!.dataSource = discountsUser!
                discountsUserTableView.tableFooterView!.isHidden = true
                discountsUserTableViewHeightConstraint.constant = CGFloat(61.0 + 50.0 * Double(discountsUser!.count)) * view.heightRatio
                
                discountsUserTableView.reloadData()
            } else {
                discountUserStackView.isHidden = true
            }
            
            discountsViewHeightConstraint.constant = discountCommonTableViewHeightConstraint.constant + discountsUserTableViewHeightConstraint.constant
            self.discountsView.layoutIfNeeded()
        } else {
            discountsView.isHidden = true
        }

        // Gallery view
        if let images = serviceProfile.images, images.count > 0 {
            galleryView.isHidden = false
            
            let galleryManager = MSMCollectionViewControllerManager(withCollectionView: galleryCollectionView)
            galleryCollectionView.collectionViewControllerManager = galleryManager
            galleryCollectionView.collectionViewControllerManager!.sectionsCount = 1
            _ = serviceProfile.images!.map { ($0 as! GalleryImage).cellHeight = 102.0 }
            galleryCollectionView.collectionViewControllerManager!.dataSource = Array(serviceProfile.images!)
            galleryCollectionView.reloadData()
            
            // Handler Image select
            galleryCollectionView.collectionViewControllerManager!.handlerCellSelectCompletion = { item in
                if item is GalleryImage {
                    self.modalViewDidShow(withHeight: 365, customSubview: PhotosGalleryView(), andValues: Array(serviceProfile.images!))
                }
            }
        } else {
            galleryView.isHidden = true
        }

        // Additional Services view
        if let additionalServicesList = serviceProfile.additionalServices, additionalServicesList.count > 0 {
            additionalServicesView.isHidden = false
            
            let additionalServicesTableManager = MSMTableViewControllerManager.init(withTableView: additionalServicesTableView,
                                                                                    andSectionsCount: 1,
                                                                                    andEmptyMessageText: "Services list is empty")
            
            additionalServicesTableView.tableViewControllerManager = additionalServicesTableManager
            additionalServicesTableView.tableViewControllerManager!.dataSource = Array(additionalServicesList)
            additionalServicesTableView.tableFooterView!.isHidden = true
            self.view.layoutIfNeeded()
            
            additionalServicesTableViewHeightConstraint.constant = CGFloat(52.0 * Double(serviceProfile.additionalServices!.count)) * view.heightRatio
            additionalServicesViewHeightConstraint.constant = 20.0 + additionalServicesTableView.frame.minY + additionalServicesTableViewHeightConstraint.constant + 20.0

            self.view.layoutIfNeeded()
            additionalServicesTableView.reloadData()            
        } else {
            additionalServicesView.isHidden = true
        }

        // Calendar view
        calendarView.isHidden = false
        orderDateComponentsDidShow()
        
        // Comment view
        
        
        // Service reviews
        var reviews = [Any]()
        
//        if let serviceReviews = serviceProfile.revi {
//            reviews.append(contentsOf: organizationReviews)
//        }
//        
//        //        let serviceReviews = CoreDataManager.instance.entitiesDidLoad(byName: "Review", andPredicateParameter: "ServiceReview")
//        //        organizationReviews!.append(contentsOf: serviceReviews!)
//        reviewsView.isHidden = (reviews.count > 0) ? false : true
//        
//        let reviewsManager = MSMCollectionViewControllerManager(withCollectionView: reviewsCollectionView)
//        reviewsCollectionView.collectionViewControllerManager = reviewsManager
//        reviewsCollectionView.collectionViewControllerManager!.sectionsCount = 1
//        reviewsCollectionView.collectionViewControllerManager!.dataSource = reviews
//        reviewsCollectionView.collectionViewControllerManager.collectionView.reloadData()
//        
//        // Handler Review select
//        reviewsCollectionView.collectionViewControllerManager!.handlerCellSelectCompletion = { item in }
//        
//        // Handler Navigation button tap
//        reviewsCollectionView.collectionViewControllerManager.handlerNavigationButtonTapCompletion = { item in
//            self.view.layoutIfNeeded()
//            self.reviewsCollectionView.scrollToItem(at: IndexPath(item: item as! Int, section: 0), at: .centeredHorizontally, animated: true)
//        }
        
        // Rating view
        if !(serviceProfile.canUserSendReview) {
            ratingView.isHidden = false
            let userReview = CoreDataManager.instance.entityDidLoad(byName: "Review", andPredicateParameter: "UserReview") as! Review
            userNameLabel.text = userReview.userName ?? "Zorro"
            cosmosView.rating = userReview.rating
            
            if let imagePath = CoreDataManager.instance.appUser.imagePath {
                userAvatarImageView.kf.setImage(with: ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: imagePath),
                                                placeholder: UIImage.init(named: "image-no-user"),
                                                options: [.transition(ImageTransition.fade(1)),
                                                          .processor(ResizingImageProcessor(referenceSize: userAvatarImageView.frame.size,
                                                                                            mode: .aspectFill))],
                                                completionHandler: { image, error, cacheType, imageURL in
                                                    self.userAvatarImageView.kf.cancelDownloadTask()
                })
            } else {
                userAvatarImageView.image = UIImage.init(named: "image-no-user")
            }
            
            cosmosView.didFinishTouchingCosmos = { _ in
                self.modalViewDidShow(withHeight: 285, customSubview: ReviewsView(), andValues: nil)
            }
            
        } else {
            ratingView.isHidden = true
        }

        smallTopBarView.actionButton.isHidden = false
        self.view.layoutIfNeeded()

        _ = dottedBorderViewsCollection.map { $0.setNeedsDisplay() }
        aroundDottedBorderView.setNeedsDisplay()

        UIView.animate(withDuration: 0.3, animations: { _ in
            self.mainStackView.isHidden = false
        })
        
        spinnerDidFinish()
    }
    
    func modalViewDidShow(withHeight height: CGFloat, customSubview subView: CustomView, andValues values: [Any]?) {
        var popupView = subView
        
        if (blackoutView == nil) {
            blackoutView = MSMBlackoutView.init(inView: view)
            blackoutView!.didShow()
        }
        
        modalView = ModalView.init(inView: blackoutView!, withHeight: height)
        
        switch subView {
        case subView as PhotosGalleryView:
            popupView = PhotosGalleryView.init(inView: modalView!)
            popupView.values = (values as! [GalleryImage]).filter({ $0.imagePath != nil })
            
        case subView as ReviewsView:
            popupView = ReviewsView.init(inView: modalView!)

        default:
            break
        }
        
        
        // Handler Cancel button tap
        popupView.handlerCancelButtonCompletion = { _ in
            self.blackoutView!.didHide()
            self.blackoutView = nil
            
            if ((popupView as? PhotosGalleryView) != nil) {
                _ = self.service.images!.map { ($0 as! GalleryImage).cellHeight = 102.0 }
            }
        }
    }

    func orderProfileDidShow(withOrderID orderID: String) {
        let orderProfile = CoreDataManager.instance.entityDidLoad(byName: "Order", andPredicateParameter: orderID) as! Order
        
        router.navigateToOrder(orderProfile)
        spinnerDidFinish()
    }
    
    func textViewPlaceholderDidUpload(_ text: String?) {
        if (text == nil) {
            commentTextView.text = ""
            commentTextView.font = UIFont.ubuntuLight12
            commentTextView.textColor = UIColor.veryLightGray
        } else if (text == "Comment".localized() || text!.isEmpty) {
            commentTextView.text = "Comment".localized()
            commentTextView.font = UIFont.ubuntuLightItalic12
            commentTextView.textColor = UIColor.darkCyan
        } else {
            commentTextView.font = UIFont.ubuntuLight12
            commentTextView.textColor = UIColor.veryLightGray
        }
    }
    
    func requestParametersDidPrepare() -> [String: Any] {
        var parameters = [String: Any]()
        var subservices = [[String: Any]]()
        
        parameters["serviceId"] = service.codeID
        parameters["start"] = "\(calendarButton.titleLabel!.text!.replacingOccurrences(of: ".", with: "-")) \(calendarEndTimeButton.titleLabel!.text!)"
        parameters["duration"] = "7200000"
            //(Double(calendarEndTimeButton.titleLabel!.text!)! - Double(calendarStartTimeButton.titleLabel!.text!)!) / 60.0 / 1000.0
        let subservicesList: [AdditionalService] = additionalServicesTableView.tableViewControllerManager.dataSource.filter({ ($0 as! AdditionalService).isAvailable == true }) as! [AdditionalService]
        
        if (subservicesList.count > 0) {
            for subservice in subservicesList {
                let additionalString = ["subServiceId": subservice.codeID, "quantity": 2] as [String : Any]
                subservices.append(additionalString)
            }
            
            parameters["subServiceOrders"] = subservices
        }
        
        if let commentText = commentTextView.text {
            parameters["comment"] = commentText
        }
        
        return parameters
    }
    
    func orderDateComponentsDidShow() {
        let orderDate = Calendar.current.date(from: orderDateComponents!)
        let startTimeDate = Calendar.current.date(from: orderStartTimeComponents!)
        let endTimeDate = Calendar.current.date(from: orderEndTimeComponents!)
        
        calendarButton.setAttributedTitle(NSAttributedString.init(string: orderDate!.convertToString(withStyle: .DateDot), attributes: UIFont.ubuntuLightVeryLightOrange16), for: .normal)
        calendarStartTimeButton.setAttributedTitle(NSAttributedString.init(string: startTimeDate!.convertToString(withStyle: .Time), attributes: UIFont.ubuntuLightVeryLightOrange16), for: .normal)
        calendarEndTimeButton.setAttributedTitle(NSAttributedString.init(string: endTimeDate!.convertToString(withStyle: .Time), attributes: UIFont.ubuntuLightVeryLightOrange16), for: .normal)
    }

    
    // MARK: - Transition
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        _ = dottedBorderViewsCollection.map { $0.setNeedsDisplay() }
        aroundDottedBorderView.setNeedsDisplay()
        smallTopBarView.setNeedsDisplay()
        galleryCollectionView.reloadData()

//        // Album
//        if newCollection.verticalSizeClass == .compact {
//            scrollViewTopConstraint.constant = smallTopBarView.frame.height + 20.0 - 50.0
//        } else {
//            scrollViewTopConstraint.constant = smallTopBarView.frame.height + 20.0 - 30.0
//        }
//        
//        self.view.layoutIfNeeded()
    }
    
    
    // MARK: - Actions
    @IBAction func handlerFavoriteButtonTap(_ sender: UIButton) {
        guard isNetworkAvailable else {
            return
        }
        
        sender.tag = (sender.tag == 0) ? 1 : 0
        service.isFavorite = !service.isFavorite
        sender.setImage(UIImage.init(named: (sender.tag == 0) ? "image-favorite-star-normal": "image-favorite-star-selected"), for: .normal)
        
        MSMRestApiManager.instance.userRequestDidRun(.userAddRemoveFavoriteService(["service": service.codeID], true), withHandlerResponseAPICompletion: { responseAPI in
            if (responseAPI?.code == 200) {
                self.favoriteButton.setImage((self.service.isFavorite) ?    UIImage(named: "image-favorite-star-selected") :
                                                                            UIImage(named: "image-favorite-star-normal"), for: .normal)
            }
        })
    }
    
    @IBAction func handlerCalendarButtonTap(_ sender: UbuntuLightVeryLightOrangeButton) {
        self.router.navigateToCalendar(orderDateComponents!)
    }
    
    @IBAction func handlerSchedulerButtonTap(_ sender: UbuntuLightVeryLightOrangeButton) {
        // TODO: - ADD ENABLE ORDER BUTTON AFTER MAKE ORDER!!!
        
    }
    
    @IBAction func handlerViewOrderButtonTap(_ sender: FillVeryLightOrangeButton) {
        // API
        spinnerDidStart(view)
        
        let orderRequest = ServiceShowModels.OrderItem.RequestModel(parameters: requestParametersDidPrepare())
        interactor.orderDidLoad(withRequestModel: orderRequest)
    }
    
    func handleTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}


// MARK: - ServiceShowViewControllerInput
extension ServiceShowViewController: ServiceShowViewControllerInput {
    func serviceDidShowLoad(fromViewModel viewModel: ServiceShowModels.ServiceItem.ViewModel) {
        // Check for errors
        guard viewModel.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: {
                self.serviceProfileDidShow()
            })
            
            return
        }
        
        self.serviceProfileDidShow()
    }
    
    func orderDidShowLoad(fromViewModel viewModel: ServiceShowModels.OrderItem.ViewModel) {
        // Check for errors
        guard viewModel.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: { })
            
            return
        }
        
        self.orderProfileDidShow(withOrderID: viewModel.orderID!)
    }
}


// MARK: - UITextFieldDelegate
extension ServiceShowViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - UITextViewDelegate
extension ServiceShowViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textViewPlaceholderDidUpload((textView.text == "Comment".localized()) ? nil : textView.text)
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textViewPlaceholderDidUpload(textView.text)
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}
