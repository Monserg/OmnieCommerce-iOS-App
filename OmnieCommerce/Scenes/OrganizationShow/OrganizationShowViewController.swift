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
    var headerView: UMParallaxView?
    
    @IBOutlet var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate     =   self
            scrollView.setScrollIndicatorColor(UIColor.veryLightOrange)
        }
    }
    
    @IBOutlet weak var smallTopBarView: SmallTopBarView!

    
    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        OrganizationShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        smallTopBarView.type        =   "Child"
        topBarViewStyle             =   .Small
        setup(topBarView: smallTopBarView)
        
        viewSettingsDidLoad()
    }
    

    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Set organization title
        smallTopBarView.titleText   =   organization.name
        
        // NOTE: Ask the Interactor to do some work
        let requestModel            =   OrganizationShowModels.Something.RequestModel()
        interactor.doSomething(requestModel: requestModel)
        
        // Handler Back button tap
        smallTopBarView.handlerSendButtonCompletion = { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        // Parallax
        if (organization.headerURL != nil) {
            headerView                      =   UMParallaxView(height: 150, fixed: true)
            headerView!.backgroundColor     =   UIColor.clear
            
            // Get header image
            Alamofire.request(organization.headerURL!).responseImage { response in
                if let image = response.result.value {
                    self.headerView!.image  =   image
                }
            }

            // Add Back button
            let backButton                  =   UIButton.init(frame: CGRect.init(origin: CGPoint.init(x: 4, y: 20), size: CGSize.init(width: 44, height: 44)))
            backButton.imageEdgeInsets      =   UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            backButton.setImage(UIImage.init(named: "icon-back-bar-button-normal"), for: .normal)
            backButton.addTarget(self, action: #selector(handlerBackButtonTap), for: .touchUpInside)
            
            headerView!.addSubview(backButton)
            
            // Settings
            headerView!.maxHeight           =   150
            headerView!.minHeight           =   smallTopBarView.bounds.height
            smallTopBarView.alpha           =   0
            
            headerView?.attachTo(scrollView)
            
            scrollView.contentSize  =   CGSize(width: self.view.frame.width, height: self.view.frame.height + 150)
        }
    }
    
    
    // MARK: - Actions
    func handlerBackButtonTap(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - UIScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard headerView != nil else {
            return
        }
        
        headerView?.scrollViewDidScroll(scrollView)
        
        if (headerView!.frame.height == headerView!.minHeight && smallTopBarView.alpha == 0) {
            UIView.animate(withDuration: 0.7, animations: {
                self.smallTopBarView.alpha  =   1
                self.headerView!.alpha      =   0
            })
        } else if (headerView!.frame.height != headerView!.minHeight && headerView!.alpha == 0) {
            UIView.animate(withDuration: 0.7, animations: {
                self.smallTopBarView.alpha  =   0
                self.headerView!.alpha      =   1
            })
        }
    }
}


// MARK: - OrganizationShowViewControllerInput
extension OrganizationShowViewController: OrganizationShowViewControllerInput {
    func displaySomething(viewModel: OrganizationShowModels.Something.ViewModel) {
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
}
