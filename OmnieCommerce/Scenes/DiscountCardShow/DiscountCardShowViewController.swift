//
//  DiscountCardShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.05.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import  Kingfisher

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol DiscountCardShowViewControllerInput {
    func discountCardDidShowDelete(fromViewModel viewModel: DiscountCardShowModels.Item.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol DiscountCardShowViewControllerOutput {
    func discountCardDidDelete(withRequestModel requestModel: DiscountCardShowModels.Item.RequestModel)
}

class DiscountCardShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: DiscountCardShowViewControllerOutput!
    var router: DiscountCardShowRouter!
    
    var discountCardID: String!
    
    // Outlets
    @IBOutlet var modalView: ModalView!
    @IBOutlet weak var codeImageView: UIImageView!
    @IBOutlet weak var codeLabel: UbuntuLightVeryLightGrayLabel!
    
    @IBOutlet weak var smallTopBarView: SmallTopBarView! {
        didSet {
            smallTopBarView.actionButton.isHidden = true
        }
    }

    
    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DiscountCardShowConfigurator.sharedInstance.configure(viewController: self)
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
        
        viewSettingsDidLoad()
    }


    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Config smallTopBarView
        navigationBarView = smallTopBarView
        smallTopBarView.type = "Child"
        haveMenuItem = false

        // Load Discount Card
        if let discountCard = CoreDataManager.instance.entityBy("DiscountCard", andCodeID: discountCardID) as? DiscountCard {
            // Show control elements
            self.codeLabel.text = discountCard.barcode
            
            if let image = Barcode.generateBarcodeFrom(stringCode: discountCard.barcode, withImageSize: codeImageView.frame.size) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.codeImageView.image = image
                })
            } else {
                self.codeImageView.contentMode = .center
                self.codeImageView.backgroundColor = UIColor.init(hexString: "#273745")
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.codeImageView.image = UIImage.init(named: "image-no-photo")
                })
            }
        }
    }

    func modalViewDidShow() {
        if (blackoutView == nil) {
            blackoutView = MSMBlackoutView.init(inView: view)
            blackoutView!.didShow()
        }
        
        modalView = ModalView.init(inView: blackoutView!, withHeight: 185.0)
        let popupView = ConfirmSaveView.init(inView: modalView!, withText: "DiscountCard delete message")
        
        // Handler Cancel button tap
        popupView.handlerCancelButtonCompletion = { _ in
            self.blackoutView!.didHide()
            self.blackoutView = nil
            
            self.navigationController!.popViewController(animated: true)
        }
    }

    
    // MARK: - Transition
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        smallTopBarView.setNeedsDisplay()
        self.view.layoutIfNeeded()
    }

    
    // MARK: - Actions
    @IBAction func handlerDeleteDiscountCardButtonTap(_ sender: UbuntuLightItalicVeryLightOrangeButton) {
        guard isNetworkAvailable else {
            self.alertViewDidShow(withTitle: "Info", andMessage: "Disconnected from Network", completion: { _ in })
            
            return
        }

        spinnerDidStart(view)
        
        let discountCardRequestModel = DiscountCardShowModels.Item.RequestModel(parameters: [ "id": discountCardID] )
        interactor.discountCardDidDelete(withRequestModel: discountCardRequestModel)
    }
    
    @IBAction func handlerEditButtonTap(_ sender: UIButton) {
        self.router.navigateToDiscountCardCreateScene(withDiscountCardID: discountCardID)
    }
    
    @IBAction func handlerBackButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - DiscountCardShowViewControllerInput
extension DiscountCardShowViewController: DiscountCardShowViewControllerInput {
    func discountCardDidShowDelete(fromViewModel viewModel: DiscountCardShowModels.Item.ViewModel) {
        spinnerDidFinish()
        
        // Check for errors
        guard viewModel.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: { _ in })
            return
        }
        
        // Show success modal view
        modalViewDidShow()
    }
}
