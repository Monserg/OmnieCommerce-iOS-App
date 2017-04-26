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
    func organizationDidShowLoad(fromViewModel viewModel: OrganizationShowModels.OrganizationItem.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol OrganizationShowViewControllerOutput {
    func organizationDidLoad(withRequestModel requestModel: OrganizationShowModels.OrganizationItem.RequestModel)
}

class OrganizationShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: OrganizationShowViewControllerOutput!
    var router: OrganizationShowRouter!
    
    var organization: Organization!
    var headerView: HeaderImageView?
    var backButton: UIButton?
    var wasLaunchedAPI = false
    
    // Action buttons
    @IBOutlet weak var animationButton: FillColorButton!
    @IBOutlet weak var cardButton: FillColorButton!
    @IBOutlet weak var cardLabel: UbuntuLightVeryLightGrayLabel!    
    @IBOutlet weak var priceButton: FillColorButton!
    @IBOutlet weak var priceLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var messageButton: FillColorButton!
    @IBOutlet weak var messageLabel: UbuntuLightVeryLightGrayLabel!
    
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
    @IBOutlet weak var logoImageView: CustomImageView!
    @IBOutlet weak var nameLabel: CustomLabel!
    @IBOutlet weak var favoriteButton: CustomButton!
    @IBOutlet weak var phonesImageView: UIImageView!
    @IBOutlet weak var phonesButton: CustomButton!
    @IBOutlet weak var scheduleImageView: UIImageView!
    @IBOutlet weak var scheduleButton: CustomButton!
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSettingsDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }


    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Config smallTopBarView
        navigationBarView = smallTopBarView
        smallTopBarView.type = "Child"
        smallTopBarView.titleText = organization.name
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
        let organizationRequestModel = OrganizationShowModels.OrganizationItem.RequestModel(parameters: ["id": organization.codeID])
        interactor.organizationDidLoad(withRequestModel: organizationRequestModel)
    }
    
    func modalViewDidShow(withHeight height: CGFloat, customSubview subView: CustomView, andValues values: [Any]?) {
        var popupView = subView
        
        if (blackoutView == nil) {
            blackoutView = MSMBlackoutView.init(inView: view)
            blackoutView!.didShow()
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
            
        case subView as BlackListView:
            popupView = BlackListView.init(inView: modalView!)
            
        case subView as PhotosGalleryView:
            popupView = PhotosGalleryView.init(inView: modalView!)
            popupView.values = (values as! [GalleryImage]).filter({ $0.imagePath != nil })
            
        default:
            break
        }
        
        
        // Handler Cancel button tap
        popupView.handlerCancelButtonCompletion = { _ in
            self.blackoutView!.didHide()
            self.blackoutView = nil
            
            if ((popupView as? PhotosGalleryView) != nil) {
                _ = self.organization.images!.map { ($0 as! GalleryImage).cellHeight = 102.0 }
            }
        }
    }

    func organizationProfileDidShow() {
        // Setting Organization profile info
        let organizationProfile = CoreDataManager.instance.entityDidLoad(byName: "Organization", andPredicateParameter: organization.codeID) as! Organization
        
        // Parallax Header view
        if let headerURL = organizationProfile.headerURL {
            headerView = HeaderImageView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: view.frame.width, height: 150)))
            smallTopBarView.actionButton.isHidden = true
            
            // Set Header image
            headerView!.imageView.kf.setImage(with: ImageResource(downloadURL: URL(string: headerURL)!, cacheKey: "imagePath-\(organization.codeID)"),
                                              placeholder: UIImage.init(named: "image-no-photo"),
                                              options: [.transition(ImageTransition.fade(1)),
                                                        .processor(ResizingImageProcessor(referenceSize: headerView!.frame.size,
                                                                                          mode: .aspectFit))],
                                              completionHandler: { image, error, cacheType, imageURL in
                                                self.headerView!.kf.cancelDownloadTask()
            })
        
            // Settings
            scrollView.parallaxHeader.view = headerView
            scrollView.parallaxHeader.height = 150
            scrollView.parallaxHeader.mode = .fill
            scrollView.parallaxHeader.minimumHeight = smallTopBarView.frame.height
            scrollView.parallaxHeader.delegate = self
            scrollView.showsVerticalScrollIndicator = true
         
            UIView.animate(withDuration: 0.3, animations: { _ in
                self.smallTopBarView.didHide()
            })
            
            scrollView.scrollIndicatorInsets = UIEdgeInsets(top: scrollView.parallaxHeader.view!.frame.maxY, left: 0, bottom: 0, right: 0)
        } else {
            scrollViewTopConstraint.constant = smallTopBarView.frame.height - ((UIApplication.shared.statusBarOrientation.isPortrait) ? 30.0 : 30.0)
            self.view.layoutIfNeeded()
            scrollView.scrollsToTop = true
            scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
            
            UIView.animate(withDuration: 0.3, animations: { _ in
                self.smallTopBarView.didShow()
            })
        }
        
        // Info view
        nameLabel.text = organization.name
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

        favoriteButton.tag = (organization.isFavorite) ? 1 : 0
        favoriteButton.setImage(UIImage.init(named: (favoriteButton.tag == 0) ? "image-favorite-star-normal" : "image-favorite-star-selected"), for: .normal)
        
        // Set Avatar image
        if let imagePath = organizationProfile.logoURL {
            logoImageView!.kf.setImage(with: ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: imagePath),
                                       placeholder: UIImage.init(named: "image-no-organization"),
                                       options: [.transition(ImageTransition.fade(1)),
                                                 .processor(ResizingImageProcessor(referenceSize: logoImageView!.frame.size,
                                                                                   mode: .aspectFit))],
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
        
        // Discounts view 
        if let discounts = organizationProfile.discounts, discounts.count > 0 {
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
        if let images = organizationProfile.images, images.count > 0 {
            galleryView.isHidden = false
            
            let galleryManager = MSMCollectionViewControllerManager(withCollectionView: galleryCollectionView)
            galleryCollectionView.collectionViewControllerManager = galleryManager
            galleryCollectionView.collectionViewControllerManager!.sectionsCount = 1
            _ = organizationProfile.images!.map { ($0 as! GalleryImage).cellHeight = 102.0 }
            galleryCollectionView.collectionViewControllerManager!.dataSource = Array(organizationProfile.images!)
            galleryCollectionView.reloadData()
            
            // Handler Image select
            galleryCollectionView.collectionViewControllerManager!.handlerCellSelectCompletion = { item in
                if item is GalleryImage {
                    self.modalViewDidShow(withHeight: 365, customSubview: PhotosGalleryView(), andValues: Array(organizationProfile.images!))
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
                    // TODO: - ADD TRANSITION TO SERVICE PROFILE SCENE
                }
            }
        } else {
            servicesView.isHidden = true
        }
        
        // Organization reviews
        var reviews = [Any]()
        
        if let organizationReviews = organizationProfile.organizationReviews {
            reviews.append(contentsOf: organizationReviews)
        }
        
//        let serviceReviews = CoreDataManager.instance.entitiesDidLoad(byName: "Review", andPredicateParameter: "ServiceReview")
//        organizationReviews!.append(contentsOf: serviceReviews!)
        reviewsView.isHidden = (reviews.count > 0) ? false : true
        
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

        // Rating view
        if (organizationProfile.canUserSendReview) {
            ratingView.isHidden = false
            let userReview = CoreDataManager.instance.entityDidLoad(byName: "Review", andPredicateParameter: "UserReview") as! Review
            userNameLabel.text = userReview.userName ?? "Zorro"
            cosmosView.rating = userReview.rating
            
            if let imagePath = CoreDataManager.instance.appUser.imagePath {
                userAvatarImageView.kf.setImage(with: ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: imagePath),
                                                placeholder: UIImage.init(named: "image-no-user"),
                                                options: [.transition(ImageTransition.fade(1)),
                                                          .processor(ResizingImageProcessor(referenceSize: userAvatarImageView.frame.size,
                                                                                            mode: .aspectFit))],
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
        if newCollection.verticalSizeClass == .compact {
            scrollViewTopConstraint.constant = smallTopBarView.frame.height + 20.0 - 50.0
        } else {
            scrollViewTopConstraint.constant = smallTopBarView.frame.height + 20.0 - 30.0
        }
        
        self.view.layoutIfNeeded()
    }

    
    // MARK: - Actions
    @IBAction func handlerBackButtonTap(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handlerAddressButtonTap(_ sender: CustomButton) {
        router.navigateToOrganizationsMapShowScene(organization)
    }
    
    @IBAction func handlerPhonesButtonTap(_ sender: CustomButton) {
        guard (organization.phones?.count)! > 0 else {
            alertViewDidShow(withTitle: "Info", andMessage: "Phones list is empty", completion: { _ in })
            return
        }
        
        if (organization.phones!.count > 0) {
            modalViewDidShow(withHeight: 185, customSubview: PhonesView(), andValues: Array(organization.phones!))
        }
    }
    
    @IBAction func handlerScheduleButtonTap(_ sender: CustomButton) {
        modalViewDidShow(withHeight: 185, customSubview: ScheduleView(), andValues: Array(organization.schedules!))
    }
    
    @IBAction func handlerFavoriteButtonTap(_ sender: UIButton) {
        guard isNetworkAvailable else {
            return
        }
        
        sender.tag = (sender.tag == 0) ? 1 : 0
        organization.isFavorite = !organization.isFavorite
        sender.setImage(UIImage.init(named: (sender.tag == 0) ? "image-favorite-star-normal" : "image-favorite-star-selected"), for: .normal)
        
        MSMRestApiManager.instance.userRequestDidRun(.userAddRemoveOrganizationToFavorite(["organization" : organization.codeID], true), withHandlerResponseAPICompletion: { responseAPI in
            if (responseAPI?.code == 200) {
                self.favoriteButton.setImage((self.organization.isFavorite) ?   UIImage(named: "image-favorite-star-selected") :
                                                                                UIImage(named: "image-favorite-star-normal"), for: .normal)
            }
        })
    }
    
    @IBAction func handlerAllServicesButtonTap(_ sender: FillVeryLightOrangeButton) {
        router.navigateToServicesShowScene(Array(organization.services!) as! [Service])
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
        }, completion: { _ in
            self.animationButton.tag = 0
            self.blackoutView!.didHide()
            self.blackoutView = nil
        })

        // Handler action button tap
        switch sender.tag {
        // Card
        case 1:
            // TODO: - ADD TRANSITION TO ...
            break
            
        // Price
        case 2:
            // TODO: - ADD TRANSITION TO ...
            break
            
        // Message
        case 3:
            // TODO: - ADD TRANSITION TO ...
            break
            
        default:
            break
        }
    }
    
}


// MARK: - OrganizationShowViewControllerInput
extension OrganizationShowViewController: OrganizationShowViewControllerInput {
    func organizationDidShowLoad(fromViewModel viewModel: OrganizationShowModels.OrganizationItem.ViewModel) {
        // Check for errors
        guard viewModel.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: {
                self.organizationProfileDidShow()
            })
            
            return
        }

        self.organizationProfileDidShow()
    }
}


// MARK: - MXScrollViewDelegate
extension OrganizationShowViewController: MXScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.indicatorDidChange(UIColor.veryLightOrange)
    }
}


// MARK: - MXParallaxHeaderDelegate
extension OrganizationShowViewController: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        if (0...0.4 ~= parallaxHeader.progress) {
            parallaxHeader.view?.didHide()
            smallTopBarView.didShow()
        } else {
            parallaxHeader.view?.didShow()
            smallTopBarView.didHide()
        }
    }
}
