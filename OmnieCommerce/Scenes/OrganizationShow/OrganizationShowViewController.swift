//
//  OrganizationShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 26.02.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import Cosmos
import Kingfisher
import MXParallaxHeader

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol OrganizationShowViewControllerInput {
    func organizationRatingDidShowSend(fromViewModel viewModel: OrganizationShowModels.Rating.ViewModel)
    func organizationDidShowLoad(fromViewModel viewModel: OrganizationShowModels.OrganizationItem.ViewModel)
    func businessCardDidShowCreateFromOrganization(fromViewModel viewModel: OrganizationShowModels.BusinessCard.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol OrganizationShowViewControllerOutput {
    func organizationRatingDidSend(withRequestModel requestModel: OrganizationShowModels.Rating.RequestModel)
    func organizationDidLoad(withRequestModel requestModel: OrganizationShowModels.OrganizationItem.RequestModel)
    func businessCardDidCreateFromOrganization(withRequestModel requestModel: OrganizationShowModels.BusinessCard.RequestModel)
}

class OrganizationShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: OrganizationShowViewControllerOutput!
    var router: OrganizationShowRouter!
    
    var organizationID: String!
    var organizationProfile: Organization!
    var headerView: HeaderImageView?
    var backButton: UIButton?
    var wasLaunchedAPI = false
    
    
    // MARK: - Outlets
    // Action buttons
    @IBOutlet weak var animationButton: FillColorButton!
    @IBOutlet weak var cardButton: FillColorButton!
    @IBOutlet weak var cardLabel: UbuntuLightVeryLightGrayLabel!    
    @IBOutlet weak var priceButton: FillColorButton!
    @IBOutlet weak var priceLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var messageButton: FillColorButton!
    @IBOutlet weak var messageLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var headerBackButton: UIButton!
    
    @IBOutlet var scrollView: MXScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet var modalView: ModalView?
    @IBOutlet weak var mainStackView: UIStackView!
    
    // Info view
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var nameLabel: CustomLabel!
    @IBOutlet weak var favoriteButton: CustomButton!
    @IBOutlet weak var phonesImageView: UIImageView!
    @IBOutlet weak var phonesButton: CustomButton!
    @IBOutlet weak var scheduleImageView: UIImageView!
    @IBOutlet weak var scheduleButton: CustomButton!
    @IBOutlet weak var logoImageView: CustomImageView!
    
    @IBOutlet var dottedBorderViewsCollection: [DottedBorderView]! {
        didSet {
            _ = dottedBorderViewsCollection.map { $0.style = .BottomDottedLine }
        }
    }

    // Title view
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UbuntuLightSoftCyanLabel!
    @IBOutlet weak var titleViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentLabel: UbuntuLightVeryLightGrayLabel! {
        didSet {
            contentLabel.numberOfLines = 0
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
    
    // Service view
    @IBOutlet weak var servicesView: UIView!
    @IBOutlet weak var servicesButtonView: UIView!
    @IBOutlet weak var servicesViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var servicesTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var servicesTableView: MSMTableView! {
        didSet {
            servicesTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            servicesTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
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
        
        OrganizationShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if (blackoutView != nil) {
            modalView?.center = blackoutView!.center
        }
        
        guard let flowLayout = reviewsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.itemSize = reviewsCollectionView.frame.size
        flowLayout.invalidateLayout()
        
        galleryCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        viewSettingsDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }


    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Config smallTopBarView
        navigationBarView = smallTopBarView
        smallTopBarView.type = "Child"
        haveMenuItem = false
        
        // Handler Back button tap
        smallTopBarView.handlerSendButtonCompletion = { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }

        spinnerDidStart(view)
        wasLaunchedAPI = true

        guard isNetworkAvailable else {
            organizationProfileDidShow()
            return
        }
        
        // Load Organization profile data
        let organizationRequestModel = OrganizationShowModels.OrganizationItem.RequestModel(parameters: ["id": organizationID])
        interactor.organizationDidLoad(withRequestModel: organizationRequestModel)
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
            
        case subView as ScheduleView:
            popupView = ScheduleView.init(inView: modalView!)
            popupView.values = values as! [Schedule]
            
        case subView as ReviewsView:
            popupView = ReviewsView.init(inView: modalView!)
            popupView.values = values as! [String]
            
            // Handler Send button tap completion
            (popupView as! ReviewsView).handlerSendButtonCompletion = { parameters in
                if (parameters == nil) {
                    self.alertViewDidShow(withTitle: "Error", andMessage: "Disconnected from Network", completion: {_ in })
                } else {
                    // TODO: - ADD API "SEND REVIEW TO SERVER"
                    // Send Organization rating
                    let organizationRatingRequestModel = OrganizationShowModels.Rating.RequestModel(parameters: parameters as! [String: AnyObject])
                    self.interactor.organizationRatingDidSend(withRequestModel: organizationRatingRequestModel)
                }
            }
            
        case subView as BlackListView:
            popupView = BlackListView.init(inView: modalView!)
            
        case subView as PhotosGalleryView:
            popupView = PhotosGalleryView.init(inView: modalView!)
            popupView.values = values as! [GalleryImage]

        case subView as ConfirmSaveView:
            popupView = ConfirmSaveView.init(inView: modalView!, withText: "BussinessСard create message")

        default:
            break
        }
        
        // Handler Cancel button tap
        popupView.handlerCancelButtonCompletion = { _ in
            self.blackoutView?.didHide()
            self.blackoutView = nil
            self.revealViewController().panGestureRecognizer().isEnabled = true

            if ((popupView as? PhotosGalleryView) != nil) {
                _ = self.organizationProfile.images!.map { ($0 as! GalleryImage).cellHeight = 102.0 }
            }
        }
    }

    func organizationProfileDidShow() {
        // Setting Organization profile info
        organizationProfile = CoreDataManager.instance.entityBy("Organization", andCodeID: organizationID) as! Organization
        smallTopBarView.titleText = organizationProfile.name

        // Parallax Header view
        if let headerID = organizationProfile.headerID, headerView == nil {
            headerView = HeaderImageView.init(frame: .zero)
            smallTopBarView.actionButton.isHidden = true
            headerBackButton.isHidden = false
            headerView!.spinnerView.startAnimating()
            
            // Set Header image
            headerView!.imageView.kf.setImage(with: ImageResource(downloadURL: headerID.convertToURL(withSize: .Original, inMode: .Get), cacheKey: headerID),
                                              placeholder: nil,
                                              options: [.transition(ImageTransition.fade(1)),
                                                        .processor(ResizingImageProcessor(referenceSize: CGSize.init(width: 600.0, height: 600.0 * 16.0 / 9.0), //headerView!.frame.size,
                                                                                          mode: .aspectFill))],
                                              completionHandler: { image, error, cacheType, imageURL in
                                                self.headerView!.kf.cancelDownloadTask()
                                                self.headerView!.spinnerView.stopAnimating()
            })
            
            // Settings
            scrollView.parallaxHeader.view = headerView
            scrollView.parallaxHeader.height = 250.0
            scrollView.parallaxHeader.mode = .fill
            scrollView.parallaxHeader.minimumHeight = smallTopBarView.frame.height
            scrollView.parallaxHeader.delegate = self
            scrollView.showsVerticalScrollIndicator = true
         
            UIView.animate(withDuration: 0.3, animations: { _ in
                self.smallTopBarView.didHide()
            })
            
            scrollView.scrollIndicatorInsets = UIEdgeInsets(top: scrollView.parallaxHeader.view!.frame.height, left: 0, bottom: 0, right: 0)
            scrollViewTopConstraint.constant = ((UIApplication.shared.statusBarOrientation.isPortrait) ? -20.0 : 0.0)
        } else {
            if (headerView == nil) {
                scrollViewTopConstraint.constant = smallTopBarView.frame.height - 30.0
                scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
            } else {
                scrollViewTopConstraint.constant = ((UIApplication.shared.statusBarOrientation.isPortrait) ? -20.0 : 0.0)
            }
            
            self.view.layoutIfNeeded()
            scrollView.scrollsToTop = true
            
            UIView.animate(withDuration: 0.3, animations: { _ in
                self.smallTopBarView.didShow()
            })
        }
        
        // Info view
        nameLabel.text = organizationProfile.name
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.numberOfLines = 2
        nameLabel.adjustsFontSizeToFitWidth = false
        
        if let phones = organizationProfile.phones, phones.count > 0 {
            phonesImageView.isHidden = false
            phonesButton.isHidden = false
        } else {
            phonesImageView.isHidden = true
            phonesButton.isHidden = true
        }
        
        if let schedules = organizationProfile.schedules, schedules.count > 0 {
            scheduleImageView.isHidden = false
            scheduleButton.isHidden = false
        } else {
            scheduleImageView.isHidden = true
            scheduleButton.isHidden = true
        }

        favoriteButton.tag = (organizationProfile.isFavorite) ? 1 : 0
        favoriteButton.setImage(UIImage.init(named: (favoriteButton.tag == 0) ? "image-favorite-star-normal" : "image-favorite-star-selected"), for: .normal)
        
        // Set Avatar image
        if let imageID = organizationProfile.imageID {
            logoImageView!.kf.setImage(with: ImageResource(downloadURL: imageID.convertToURL(withSize: .Small, inMode: .Get), cacheKey: imageID),
                                       placeholder: nil,
                                       options: [.transition(ImageTransition.fade(1)),
                                                 .processor(ResizingImageProcessor(referenceSize: logoImageView!.frame.size,
                                                                                   mode: .aspectFill))],
                                       completionHandler: { image, error, cacheType, imageURL in
                                        self.logoImageView!.kf.cancelDownloadTask()

            })
        } else {
            logoImageView!.image = UIImage.init(named: "image-no-organization")
        }
        
        
        // Title view
        if let descriptionTitle = organizationProfile.descriptionTitle, let descriptionContent = organizationProfile.descriptionContent {
            if (descriptionTitle.isEmpty && descriptionContent.isEmpty) {
                titleView.isHidden = true
            } else {
                titleView.isHidden = false
                titleLabel.text = descriptionTitle
                contentLabel.text = descriptionContent
                contentLabel.sizeToFit()
                titleViewHeightConstraint.constant = contentLabel.frame.maxY + 19.0
                view.layoutIfNeeded()
            }
        } else {
            titleView.isHidden = true
        }
        
        // Common discounts
        var discounts: Int = 0
        
        if let discountsCommon = CoreDataManager.instance.entitiesDidLoad(byName: "Discount", andPredicateParameters: NSPredicate.init(format: "ANY isUserDiscount == \(false) AND organizationID == %@", organizationProfile.codeID)), discountsCommon.count > 0 {
            discountCommonStackView.isHidden = false
            discounts += discountsCommon.count
            
            let discountCommonTableManager = MSMTableViewControllerManager.init(withTableView: discountsCommonTableView,
                                                                                andSectionsCount: 1,
                                                                                andEmptyMessageText: "Common discounts list is empty")
            
            discountsCommonTableView.tableViewControllerManager = discountCommonTableManager
            discountsCommonTableView.tableViewControllerManager!.dataSource = discountsCommon
            discountsCommonTableView.tableFooterView!.isHidden = true
            discountCommonTableViewHeightConstraint.constant = CGFloat(58.0 * Double(discountsCommon.count)) * view.heightRatio + 10.0
            
            discountsCommonTableView.reloadData()
        } else {
            discountCommonStackView.isHidden = true
            discountCommonTableViewHeightConstraint.constant = 0.0
        }
        
        // User discounts
        if let discountsUser = CoreDataManager.instance.entitiesDidLoad(byName: "Discount", andPredicateParameters: NSPredicate.init(format: "ANY isUserDiscount == \(true) AND organizationID == %@", organizationProfile.codeID)), discountsUser.count > 0 {
            discountUserStackView.isHidden = false
            discounts += discountsUser.count
            
            let discountsUserTableManager = MSMTableViewControllerManager.init(withTableView: discountsUserTableView,
                                                                               andSectionsCount: 1,
                                                                               andEmptyMessageText: "User discounts list is empty")
            
            discountsUserTableView.tableViewControllerManager = discountsUserTableManager
            discountsUserTableView.tableViewControllerManager!.dataSource = discountsUser
            discountsUserTableView.tableFooterView!.isHidden = true
            discountsUserTableViewHeightConstraint.constant = CGFloat(0.0 + 58.0 * Double(discountsUser.count)) * view.heightRatio
            
            discountsUserTableView.reloadData()
        } else {
            discountUserStackView.isHidden = true
            discountsUserTableViewHeightConstraint.constant = 0.0
        }
        
        if (discounts > 0) {
            discountsViewHeightConstraint.constant = discountCommonTableViewHeightConstraint.constant + discountsUserTableViewHeightConstraint.constant
            self.discountsView.layoutIfNeeded()
        } else {
            discountsView.isHidden = true
        }
        
        // Gallery view
        if let images = organizationProfile.images, images.count > 0 {
            galleryView.isHidden = false
            
            let galleryManager = MSMCollectionViewControllerManager(withCollectionView: galleryCollectionView)
            galleryCollectionView.collectionViewControllerManager = galleryManager
            galleryCollectionView.collectionViewControllerManager!.sectionsCount = 1
            _ = organizationProfile.images!.map { ($0 as! GalleryImage).cellHeight = 102.0; ($0 as! GalleryImage).cellIdentifier = "CirclePhotoCollectionViewCell" }
            galleryCollectionView.collectionViewControllerManager!.dataSource = Array(organizationProfile.images!)
            galleryCollectionView.reloadData()
            
            // Handler Image select
            galleryCollectionView.collectionViewControllerManager!.handlerCellSelectCompletion = { item in
                if item is GalleryImage {
                    self.modalViewDidShow(withHeight: 365, customSubview: PhotosGalleryView(), andValues: Array(self.organizationProfile.images!))
                }
            }
        } else {
            galleryView.isHidden = true
        }

        // Services view
        if let servicesList = organizationProfile.services, servicesList.count > 0 {
            servicesView.isHidden = false
            
            let servicesTableManager = MSMTableViewControllerManager.init(withTableView: servicesTableView,
                                                                          andSectionsCount: 1,
                                                                          andEmptyMessageText: "Services list is empty")
           
            servicesTableView.tableViewControllerManager = servicesTableManager
            
            _ = servicesList.map {  ($0 as! Service).cellIdentifier = "FavoriteServiceTableViewCell";
                                    ($0 as! Service).cellHeight = 60.0;
                                    ($0 as! Service).isNameNeedHide = true;
                                    ($0 as! Service).needBackgroundColorSet = true;
                                    ($0 as! Service).organizationName = organizationProfile.name;
                                }
            
            servicesTableView.tableViewControllerManager!.dataSource = Array(servicesList)
            servicesTableView.tableFooterView!.isHidden = true
            self.view.layoutIfNeeded()
            
            if (organizationProfile.services!.count >= 3) {
                servicesButtonView.isHidden = false
                servicesTableViewHeightConstraint.constant = CGFloat(60.0 * 3.0) * view.heightRatio
                servicesViewHeightConstraint.constant = 20.0 + servicesTableView.frame.minY + servicesTableViewHeightConstraint.constant + servicesButtonView.frame.height + 20.0
            } else {
                servicesButtonView.isHidden = true
                servicesTableViewHeightConstraint.constant = CGFloat(60.0 * Double(organizationProfile.services!.count)) * view.heightRatio
                servicesViewHeightConstraint.constant = 20.0 + servicesTableView.frame.minY + servicesTableViewHeightConstraint.constant + 20.0
            }
            
            self.view.layoutIfNeeded()
            servicesTableView.reloadData()
            
            // Handler Service select
            servicesTableView.tableViewControllerManager!.handlerSelectRowCompletion = { item in
                if item is Service {
                    self.router.navigateToServiceShowScene(withServiceID: (item as! Service).codeID, andOrganizationID: self.organizationProfile.codeID)
                }
            }
        } else {
            servicesView.isHidden = true
        }
        
        // Reviews
        var reviews = [Review]()

        // Service reviews
        if let serviceReviews = CoreDataManager.instance.entitiesDidLoad(byName: "Review", andPredicateParameters: NSPredicate.init(format: "ANY organizationID == %@ AND typeValue == %@", organizationProfile.codeID, "ServiceReview")), serviceReviews.count > 0 {
            reviews += serviceReviews as! [Review]
        }

        // Organization reviews
        if let organizationReviews = CoreDataManager.instance.entitiesDidLoad(byName: "Review", andPredicateParameters: NSPredicate.init(format: "ANY organizationID == %@ AND typeValue == %@", organizationProfile.codeID, "OrganizationReview")), organizationReviews.count > 0 {
            reviews += organizationReviews as! [Review]
        }

        if (reviews.count > 0) {
            reviewsView.isHidden = false
            
            let reviewsManager = MSMCollectionViewControllerManager(withCollectionView: reviewsCollectionView)
            reviewsCollectionView.collectionViewControllerManager = reviewsManager
            reviewsCollectionView.collectionViewControllerManager!.sectionsCount = 1
            reviewsCollectionView.collectionViewControllerManager!.dataSource = reviews
            reviewsCollectionView.collectionViewControllerManager.collectionView.reloadData()
            
            // Handler Review select
            reviewsCollectionView.collectionViewControllerManager!.handlerCellSelectCompletion = { item in }
            
            // Handler Navigation button tap
            reviewsCollectionView.collectionViewControllerManager.handlerNavigationButtonTapCompletion = { item in
                self.view.layoutIfNeeded()
                self.reviewsCollectionView.scrollToItem(at: IndexPath(item: item as! Int, section: 0), at: .centeredHorizontally, animated: true)
            }
        } else {
            reviewsView.isHidden = true
        }

        // User review
        if (organizationProfile.canUserSendReview) {
            ratingView.isHidden = false
            
            let userReview = CoreDataManager.instance.entityBy("Review", andCodeID: "\(organizationProfile.codeID)-UserReview") as! Review
            userNameLabel.text = userReview.userName ?? "Zorro"
            cosmosView.rating = userReview.rating
            
            if let imagePath = userReview.imageID {
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
                self.modalViewDidShow(withHeight: 285, customSubview: ReviewsView(), andValues: [self.organizationProfile.codeID])
            }
        } else {
            ratingView.isHidden = true
            
            // Hide last dotted line in Services view
            _ = dottedBorderViewsCollection.filter({ $0.tag == 100 }).map({ $0.isHidden = reviewsView.isHidden && ratingView.isHidden })
        }        
        
        _ = dottedBorderViewsCollection.map { $0.setNeedsDisplay() }

        UIView.animate(withDuration: 0.3, animations: { _ in
            self.mainStackView.isHidden = false
        })

        spinnerDidFinish()
    }

    
    // MARK: - Transition
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        _ = dottedBorderViewsCollection.map { $0.setNeedsDisplay() }
        smallTopBarView.setNeedsDisplay()
        galleryCollectionView.reloadData()

        // Album
//        if newCollection.verticalSizeClass == .compact {
//            scrollViewTopConstraint.constant = smallTopBarView.frame.height + 20.0 - 50.0
//        } else {
//            scrollViewTopConstraint.constant = smallTopBarView.frame.height + 20.0 - 30.0
//        }
        
        self.view.layoutIfNeeded()
    }

    
    // MARK: - Actions
    @IBAction func handlerBackButtonTap(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handlerAddressButtonTap(_ sender: CustomButton) {
        guard isNetworkAvailable else {
            self.router.navigateToOrganizationsMapShowScene(self.organizationProfile)
            return
        }
        
        if let placeID = organizationProfile.placeID {
            organizationProfile.googlePlaceDidLoad(positionID: placeID, completion: { _ in
                CoreDataManager.instance.didSaveContext()
                self.router.navigateToOrganizationsMapShowScene(self.organizationProfile)
            })
        }
    }
    
    @IBAction func handlerPhonesButtonTap(_ sender: CustomButton) {
        if let phones = organizationProfile.phones, phones.count > 0 {
            modalViewDidShow(withHeight: 185, customSubview: PhonesView(), andValues: Array(organizationProfile.phones!))
        } else {
            alertViewDidShow(withTitle: "Info", andMessage: "Phones list is empty", completion: { _ in })
        }
    }
    
    @IBAction func handlerScheduleButtonTap(_ sender: CustomButton) {
        modalViewDidShow(withHeight: 185, customSubview: ScheduleView(), andValues: Array(organizationProfile.schedules!))
    }
    
    @IBAction func handlerFavoriteButtonTap(_ sender: UIButton) {
        guard isNetworkAvailable else {
            return
        }
        
        sender.tag = (sender.tag == 0) ? 1 : 0
        organizationProfile.isFavorite = !organizationProfile.isFavorite
        sender.setImage(UIImage.init(named: (sender.tag == 0) ? "image-favorite-star-normal": "image-favorite-star-selected"), for: .normal)
        
        MSMRestApiManager.instance.userRequestDidRun(.userAddRemoveFavoriteOrganization(["organization": organizationProfile.codeID], true), withHandlerResponseAPICompletion: { responseAPI in
            if (responseAPI?.code == 200) {
                self.favoriteButton.setImage((self.organizationProfile.isFavorite) ?    UIImage(named: "image-favorite-star-selected") :
                                                                                        UIImage(named: "image-favorite-star-normal"), for: .normal)
            }
        })
    }
    
    @IBAction func handlerAllServicesButtonTap(_ sender: FillVeryLightOrangeButton) {
        router.navigateToServicesShowScene(Array(organizationProfile.services!) as! [Service])
    }
    
    @IBAction func handlerAnimationButtonTap(_ sender: FillColorButton) {
        UIView.animate(withDuration: 0.3, animations: {
            sender.transform = (sender.tag == 0) ? CGAffineTransform.init(rotationAngle: .pi/4) : CGAffineTransform.identity
            
            if (sender.tag == 1) {
                self.blackoutView!.didHide()
                self.blackoutView = nil
            } else if (self.blackoutView == nil) {
                self.blackoutView = MSMBlackoutView.init(inView: self.view)
                self.blackoutView!.didShow()
                self.view.bringSubview(toFront: self.messageButton)
                self.view.bringSubview(toFront: self.messageLabel)
                self.view.bringSubview(toFront: self.priceButton)
                self.view.bringSubview(toFront: self.priceLabel)
                self.view.bringSubview(toFront: self.cardButton)
                self.view.bringSubview(toFront: self.cardLabel)
                self.view.bringSubview(toFront: sender)
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.cardButton.transform = (sender.tag == 0) ?     CGAffineTransform.init(translationX: 0, y: -(sender.frame.height / 2 + 15.0 * self.view.heightRatio)) :
                                                                    CGAffineTransform.identity
                
                self.cardLabel.isHidden = (sender.tag == 0) ? false : true
                self.cardLabel.transform = self.cardButton.transform
                
                self.priceButton.transform = (sender.tag == 0) ?    CGAffineTransform.init(translationX: 0, y: -(sender.frame.height / 2 + self.cardButton.frame.height + (15.0 + 10.0) * self.view.heightRatio)) :
                                                                    CGAffineTransform.identity
                
                self.priceLabel.isHidden = (sender.tag == 0) ? false : true
                self.priceLabel.transform = self.priceButton.transform

                self.messageButton.transform = (sender.tag == 0) ?  CGAffineTransform.init(translationX: 0, y: -(sender.frame.height / 2 + self.cardButton.frame.height + self.priceButton.frame.height + (15.0 + 10.0 + 8.0) * self.view.heightRatio)) :
                                                                    CGAffineTransform.identity
                
                self.messageLabel.isHidden = (sender.tag == 0) ? false : true
                self.messageLabel.transform = self.messageButton.transform
            })
        }, completion: { _ in
            sender.tag = (sender.tag == 0) ? 1 : 0
        })
    }
    
    @IBAction func handlerActionButtonsTap(_ sender: FillColorButton) {
        UIView.animate(withDuration: 0.3, animations: { _ in
            self.animationButton.transform = CGAffineTransform.identity
            
            UIView.animate(withDuration: 0.5, animations: {
                self.cardButton.transform = CGAffineTransform.identity
                self.cardLabel.transform = self.cardButton.transform
                self.cardLabel.isHidden = true
                
                self.priceButton.transform = CGAffineTransform.identity
                self.priceLabel.transform = self.priceButton.transform
                self.priceLabel.isHidden = true
                
                self.messageButton.transform = CGAffineTransform.identity
                self.messageLabel.transform = self.messageButton.transform
                self.messageLabel.isHidden = true
            })
        })

        // Handler action button tap
        switch sender.tag {
        // Add Bussiness Card
        case 1:
            self.animationButton.tag = 0
            self.blackoutView!.didHide()
            self.blackoutView = nil

            let businessCardRequestModel = OrganizationShowModels.BusinessCard.RequestModel(parameters: [ "id": organizationProfile.codeID as AnyObject ])
            interactor.businessCardDidCreateFromOrganization(withRequestModel: businessCardRequestModel)
            
        // Price List
        case 2:
            self.animationButton.tag = 0
            self.blackoutView!.didHide()
            self.blackoutView = nil

            router.navigateToPriceListShowScene(Array(organizationProfile.services!) as! [Service])
            
        // Message
        case 3:
            // TODO: - ADD TRANSITION TO ...
            break
            
        default:
            self.animationButton.tag = 0
            self.blackoutView!.didHide()
            self.blackoutView = nil
        }
    }
    
}


// MARK: - OrganizationShowViewControllerInput
extension OrganizationShowViewController: OrganizationShowViewControllerInput {
    func organizationDidShowLoad(fromViewModel viewModel: OrganizationShowModels.OrganizationItem.ViewModel) {
        spinnerDidFinish()
        
        // Check for errors
        guard viewModel.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: {
                self.organizationProfileDidShow()
            })
            
            return
        }

        self.organizationProfileDidShow()
    }
    
    func organizationRatingDidShowSend(fromViewModel viewModel: OrganizationShowModels.Rating.ViewModel) {
        spinnerDidFinish()

        // Check for errors
        guard viewModel.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: {
                self.organizationProfileDidShow()
            })
            
            return
        }
        
        self.organizationProfileDidShow()
    }
    
    func businessCardDidShowCreateFromOrganization(fromViewModel viewModel: OrganizationShowModels.BusinessCard.ViewModel) {
        spinnerDidFinish()

        // Check for errors
        guard viewModel.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: {})
            
            return
        }
        
        self.modalViewDidShow(withHeight: 185.0, customSubview: ConfirmSaveView(), andValues: nil)
    }
}


// MARK: - MXScrollViewDelegate
extension OrganizationShowViewController: MXScrollViewDelegate {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.indicatorDidChange(UIColor.veryLightOrange)
    }
}


// MARK: - MXParallaxHeaderDelegate
extension OrganizationShowViewController: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        print(object: parallaxHeader.progress)
  
        if (0...0.2 ~= parallaxHeader.progress) {
            parallaxHeader.view?.didHide()
            headerBackButton.isHidden = true
            smallTopBarView.actionButton.isHidden = false
            smallTopBarView.didShow()
        } else {
            parallaxHeader.view?.didShow()
            headerBackButton.isHidden = false
            smallTopBarView.actionButton.isHidden = true
            smallTopBarView.didHide()
        }
    }
}
