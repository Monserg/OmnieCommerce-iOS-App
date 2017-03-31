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
import Alamofire
import AlamofireImage
import MXParallaxHeader

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol OrganizationShowViewControllerInput {
    func displaySomething(viewModel: OrganizationShowModels.Something.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol OrganizationShowViewControllerOutput {
    func doSomething(requestModel: OrganizationShowModels.Something.RequestModel)
}

class OrganizationShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: OrganizationShowViewControllerOutput!
    var router: OrganizationShowRouter!
    
    var organization: Organization!
    var headerView: UIImageView?
    var backButton: UIButton?
    
    var phonesView: PhonesView?
    var scheduleView: ScheduleView?
    
    @IBOutlet var scrollView: MXScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    
    // Info view
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var logoImageView: CustomImageView!
    @IBOutlet weak var nameLabel: CustomLabel!
    @IBOutlet weak var favoriteButton: CustomButton!
    
    @IBOutlet weak var dottedBorderView: DottedBorderView! {
        didSet {
            dottedBorderView.style = .BottomDottedLine
        }
    }

    
    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        OrganizationShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSettingsDidLoad()
    }
    

    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Config smallTopBarView
        navigationBarView = smallTopBarView
        smallTopBarView.type = "Child"
        smallTopBarView.titleText = organization.name
        haveMenuItem = false
        
        // Load data
        let requestModel = OrganizationShowModels.Something.RequestModel()
        interactor.doSomething(requestModel: requestModel)
        
        // Handler Back button tap
        smallTopBarView.handlerSendButtonCompletion = { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        // Parallax
        if (organization.headerURL != nil) {
            headerView = UIImageView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: view.frame.width, height: 150)))
            headerView!.contentMode = .scaleAspectFill

            // Get header image
            Alamofire.request(organization.headerURL!).responseImage { response in
                if let image = response.result.value {
                    self.headerView!.image = image
                }
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

        if (organization.logoURL != nil) {
            Alamofire.request(organization.logoURL!).responseImage { response in
                if let image = response.result.value {
                    self.logoImageView!.image = image
                    self.logoImageView!.contentMode = .scaleAspectFit
                }
            }
        }
    }
    
    
    // MARK: - Transition
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        dottedBorderView.setNeedsDisplay()

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
        guard organization.phones != nil else {
            alertViewDidShow(withTitle: "Info", andMessage: "Phones list is empty", completion: { _ in })
           
            return
        }
        
        if (organization.phones!.count > 0) {
            self.blackoutView = MSMBlackoutView.init(inView: view)

            blackoutView!.didShow()
      
            phonesView = PhonesView.init(inView: view)
            phonesView!.phones = organization.phones!
            
            // Handler Cancel button tap
            phonesView!.handlerCancelButtonCompletion = { _ in
                self.phonesView = nil
                
                self.blackoutView!.didHide()
            }
        }
    }
    
    @IBAction func handlerScheduleButtonTap(_ sender: CustomButton) {
        self.blackoutView = MSMBlackoutView.init(inView: view)

        blackoutView!.didShow()
        
        scheduleView = ScheduleView.init(inView: view)
        scheduleView!.schedule = organization.schedule
        
        // Handler Cancel button tap
        scheduleView!.handlerCancelButtonCompletion = { _ in
            self.scheduleView = nil
            
            self.blackoutView!.didHide()
        }
    }
    
    @IBAction func handlerFavoriteButtonTap(_ sender: UIButton) {
        sender.tag = (sender.tag == 0) ? 1 : 0
        
        sender.setImage(UIImage.init(named: (sender.tag == 0) ? "image-favorite-star-normal" : "image-favorite-star-selected"), for: .normal)
        
        // TODO: - ADD API TO POST FAVORITE STATE & CHANGE ORGANIZATION PROFILE
    }
}


// MARK: - OrganizationShowViewControllerInput
extension OrganizationShowViewController: OrganizationShowViewControllerInput {
    func displaySomething(viewModel: OrganizationShowModels.Something.ViewModel) {
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
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
