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
    var headerView: UIImageView?
    var backButton: UIButton?
    var wasLaunchedAPI = false
    
    @IBOutlet var scrollView: MXScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet var modalView: ModalView?
    
    // Info view
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var logoImageView: CustomImageView!
    @IBOutlet weak var nameLabel: CustomLabel!
    @IBOutlet weak var favoriteButton: CustomButton!
    
    @IBOutlet var dottedBorderViewsCollection: [DottedBorderView]! {
        didSet {
            _ = dottedBorderViewsCollection.map { $0.style = .BottomDottedLine }
        }
    }

    // Title view
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UbuntuLightSoftCyanLabel!
    @IBOutlet weak var contentLabel: UbuntuLightVeryLightGrayLabel! {
        didSet {
            contentLabel.numberOfLines = 0
        }
    }
    
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if (!wasLaunchedAPI) {
            viewSettingsDidLoad()
        }
    }


    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Config smallTopBarView
        navigationBarView = smallTopBarView
        smallTopBarView.type = "Child"
        smallTopBarView.titleText = organization.name
        haveMenuItem = false
        
        // Load Organization profile data
        spinnerDidStart(view)
        let organizationRequestModel = OrganizationShowModels.OrganizationItem.RequestModel(parameters: ["id": organization.codeID])
        interactor.organizationDidLoad(withRequestModel: organizationRequestModel)
        wasLaunchedAPI = true

        // Handler Back button tap
        smallTopBarView.handlerSendButtonCompletion = { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }
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
            
        case subView as ScheduleView:
            popupView = ScheduleView.init(inView: modalView!)
            popupView.values = values as! [Schedule]
            
        case subView as ReviewsView:
            popupView = ReviewsView.init(inView: modalView!)
            
        case subView as BlackListView:
            popupView = BlackListView.init(inView: modalView!)
            
        case subView as PhotosGalleryView:
            popupView = PhotosGalleryView.init(inView: modalView!)
            popupView.values = values as! [GalleryImage]
            
        default:
            break
        }
        
        
        // Handler Cancel button tap
        popupView.handlerCancelButtonCompletion = { _ in
            self.blackoutView!.didHide()
            self.blackoutView = nil
        }
    }

    func organizationProfileDidShow(_ organizationProfile: Organization?, fromAPI: Bool) {
        if (fromAPI) {
            self.organization = organizationProfile!
        } else {
//            let organizationData = CoreDataManager.instance.entityDidLoad(byName: keyOrganization) as! Organization
//            self.organization = NSKeyedUnarchiver.unarchiveObject(with: organizationData.list! as Data) as! Organization
        }
        
        // Setting Organization profile info
        // Parallax
        if (organization.headerURL != nil) {
            headerView = UIImageView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: view.frame.width, height: 150)))
            headerView!.contentMode = .scaleAspectFill
            
            // Set Header image
            if let imagePath = organization.headerURL {
                headerView!.kf.setImage(with: ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: "imagePath-\(organization.codeID)"),
                                        placeholder: UIImage.init(named: "image-no-photo"),
                                        options: [.transition(ImageTransition.fade(1)),
                                                  .processor(ResizingImageProcessor(targetSize: headerView!.frame.size,
                                                                                    contentMode: .aspectFit))],
                                        completionHandler: { image, error, cacheType, imageURL in
                                            self.headerView!.kf.cancelDownloadTask()
                })
            }
            
            // Settings
            scrollView.parallaxHeader.view = headerView
            scrollView.parallaxHeader.height = 150
            scrollView.parallaxHeader.mode = .fill
            scrollView.parallaxHeader.minimumHeight = smallTopBarView.frame.height
            scrollView.parallaxHeader.delegate = self
            scrollView.showsVerticalScrollIndicator = true
            smallTopBarView.alpha = 0
            
            // Add Back button
            backButton = UIButton.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.zero))
            backButton!.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            
            backButton!.setImage(UIImage.init(named: "icon-back-bar-button-normal"), for: .normal)
            backButton!.addTarget(self, action: #selector(handlerBackButtonTap), for: .touchUpInside)
            
            view.addSubview(backButton!)
            backButton!.translatesAutoresizingMaskIntoConstraints = false
            
            backButton!.topAnchor.constraint(equalTo: view.topAnchor, constant: (UIApplication.shared.statusBarOrientation.isPortrait) ? 20 : 4).isActive = true
            backButton!.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4).isActive = true
            backButton!.heightAnchor.constraint(equalToConstant: 44).isActive = true
            backButton!.widthAnchor.constraint(equalToConstant: 44).isActive = true
            
            scrollView.scrollIndicatorInsets = UIEdgeInsets(top: scrollView.parallaxHeader.view!.frame.maxY, left: 0, bottom: 0, right: 0)
        } else {
            scrollView.transform = CGAffineTransform(translationX: 0, y: smallTopBarView.frame.maxY)
            scrollView.contentOffset = CGPoint.init(x: 0, y: smallTopBarView.frame.maxY + 70)
            scrollView.scrollIndicatorInsets = UIEdgeInsets(top: smallTopBarView.frame.maxY, left: 0, bottom: 0, right: 0)
        }
        
        // Initial Info view
        nameLabel.text = organization.name + " jashdjk hjahdjahs hahd asd asdgag dgahd ghasg hgash dgashjgd ags dgasdaseyqteyqu  i slasldklaskdasklaskdlask"
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.numberOfLines = 2
        nameLabel.adjustsFontSizeToFitWidth = false
        
        favoriteButton.tag = (organization.isFavorite) ? 1 : 0
        favoriteButton.setImage(UIImage.init(named: (favoriteButton.tag == 0) ? "image-favorite-star-normal" : "image-favorite-star-selected"), for: .normal)
        
        // Set Avatar image
        if let imagePath = organization.logoURL {
            logoImageView!.kf.setImage(with: ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: "imagePath"),
                                       placeholder: UIImage.init(named: "image-no-photo"),
                                       options: [.transition(ImageTransition.fade(1)),
                                                 .processor(ResizingImageProcessor(targetSize: logoImageView!.frame.size,
                                                                                   contentMode: .aspectFit))],
                                       completionHandler: { image, error, cacheType, imageURL in
                                        self.logoImageView!.kf.cancelDownloadTask()
            })
        } else {
            logoImageView!.image = UIImage.init(named: "image-no-photo")
        }
        
        // Title view
        if (organizationProfile?.descriptionTitle != nil && organizationProfile?.descriptionContent != nil) {
            titleView.isHidden = false
            titleLabel.text = organizationProfile?.descriptionTitle!
            contentLabel.text = organizationProfile?.descriptionContent!
            contentLabel.sizeToFit()
        }
    }

    
    // MARK: - Transition
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        _ = dottedBorderViewsCollection.map { $0.setNeedsDisplay() }

        guard headerView != nil else {
            return
        }
        
        // Portrait
        if newCollection.containsTraits(in: UITraitCollection(verticalSizeClass: .regular)) {
            backButton!.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        } else {
            backButton!.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
        }
    }

    
    // MARK: - Actions
    func handlerBackButtonTap(_ sender: UIButton) {
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
            modalViewDidShow(withHeight: 185, customSubview: PhonesView(), andValues: organization.phones!)
        }
    }
    
    @IBAction func handlerScheduleButtonTap(_ sender: CustomButton) {
        modalViewDidShow(withHeight: 185, customSubview: ScheduleView(), andValues: organization.schedules!)
    }
    
    @IBAction func handlerFavoriteButtonTap(_ sender: UIButton) {
        sender.tag = (sender.tag == 0) ? 1 : 0
        
        sender.setImage(UIImage.init(named: (sender.tag == 0) ? "image-favorite-star-normal" : "image-favorite-star-selected"), for: .normal)
        
        // TODO: - ADD API TO POST FAVORITE STATE & CHANGE ORGANIZATION PROFILE
//        isFavorite = !isFavorite
//        
//        MSMRestApiManager.instance.userAddRemoveOrganizationToFavorite(["organization" : organizationID], withHandlerResponseAPICompletion: { responseAPI in
//            if (responseAPI?.code == 200) {
//                self.favoriteButton.setImage((self.isFavorite) ?    UIImage(named: "image-favorite-star-selected") :
//                    UIImage(named: "image-favorite-star-normal"), for: .normal)
//                
//                self.handlerFavoriteButtonTapCompletion!(self.organizationID)
//            }
//        })

    }
    
    // TESTED
    @IBAction func handlerShowPopupView(_ sender: UIButton) {
//        modalViewDidShow(withHeight: 285, customSubview: ReviewsView(), andValues: nil)
//        modalViewDidShow(withHeight: 185, customSubview: BlackListView(), andValues: nil)
        modalViewDidShow(withHeight: 365, customSubview: PhotosGalleryView(), andValues: organization.gallery)
    }
}


// MARK: - OrganizationShowViewControllerInput
extension OrganizationShowViewController: OrganizationShowViewControllerInput {
    func organizationDidShowLoad(fromViewModel viewModel: OrganizationShowModels.OrganizationItem.ViewModel) {
        spinnerDidFinish()
        CoreDataManager.instance.didSaveContext()
        
        // Load Organization profile from CoreData
        guard isNetworkAvailable else {
            organizationProfileDidShow(nil, fromAPI: false)
            return
        }
        
        // Load Organization profile from API
        let organizationProfile = viewModel.organizationItem!
        self.organizationProfileDidShow(organizationProfile, fromAPI: true)
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
            
//            scrollView.scrollIndicatorInsets    =   UIEdgeInsets(top: smallTopBarView.frame.height, left: 0, bottom: 0, right: 0)

        } else {
            parallaxHeader.view?.didShow()
            smallTopBarView.didHide()

//            scrollView.scrollIndicatorInsets    =   UIEdgeInsets(top: scrollView.parallaxHeader.height, left: 0, bottom: 0, right: 0)
        }
        
        //        guard headerView != nil else {
        //            scrollView.transform        =   CGAffineTransform(translationX: 0, y: smallTopBarView.frame.height - 30)
        //            scrollView.contentInset     =   UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        //
        //            return
        //        }
        //
        //        headerView!.scrollViewDidScroll(scrollView)
        //
        //        if smallTopBarView.frame.height...(headerView!.maxHeight + 20) ~= headerView!.frame.height {
        //            scrollView.scrollIndicatorInsets    =   UIEdgeInsets(top: abs(scrollView.contentOffset.y), left: 0, bottom: 0, right: 0)
        //        }
        //
        ////        if headerView!.minHeight...smallTopBarView.frame.height ~= headerView!.frame.height {
        ////            scrollView.scrollIndicatorInsets    =   UIEdgeInsets(top: smallTopBarView.frame.height, left: 0, bottom: 0, right: 0)
        ////        }
        //
        //        if (headerView!.frame.height == headerView!.minHeight && smallTopBarView.alpha == 0) {
        //            UIView.animate(withDuration: 0.7, animations: {
        //                self.smallTopBarView.alpha      =   1
        //                self.headerView!.alpha          =   0
        //            })
        //        } else if (headerView!.frame.height != headerView!.minHeight && headerView!.alpha == 0) {
        //            UIView.animate(withDuration: 0.7, animations: {
        //                self.smallTopBarView.alpha      =   0
        //                self.headerView!.alpha          =   1
        //            })
        //        }

    }
}
