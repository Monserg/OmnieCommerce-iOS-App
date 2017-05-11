//
//  OrderShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 29.04.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol OrderShowViewControllerInput {
    func orderDidShowLoad(fromViewModel viewModel: OrderShowModels.OrderItem.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol OrderShowViewControllerOutput {
    func orderDidLoad(withRequestModel requestModel: OrderShowModels.OrderItem.RequestModel)
}

enum OrderMode {
    case Edit
    case Preview
}

class OrderShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: OrderShowViewControllerOutput!
    var router: OrderShowRouter!
    
    var order: Order!
    var orderMode: OrderMode = .Edit
    
    // Outlets
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet var modalView: ModalView!
    
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

    // Info view
    
    
    // Price view
    @IBOutlet weak var priceLabel: UbuntuLightVeryLightOrangeLabel!
    
    
    // Action view
    @IBOutlet weak var checkButton: DLRadioButton! {
        didSet {
            checkButton.setTitle("Save as template".localized(), for: .normal)
        }
    }
    
    
    
    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        OrderShowConfigurator.sharedInstance.configure(viewController: self)
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
        haveMenuItem = false
        
        // Handler Back button tap
        smallTopBarView.handlerSendButtonCompletion = { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        spinnerDidStart(view)
        
        guard isNetworkAvailable else {
            orderProfileDidShow()
            return
        }
        
        // Load Order profile data
        if let orderItem = order {
            let orderRequestModel = OrderShowModels.OrderItem.RequestModel(parameters: ["id": orderItem.codeID])
            interactor.orderDidLoad(withRequestModel: orderRequestModel)
        } else {
            orderProfileDidShow()
        }
    }
    
    func orderProfileDidShow() {
        // Info view
        
        
        // Price view
        priceLabel.text = "\(420) грн."
        
        // Action view
        checkButton.sizeToFit()
        spinnerDidFinish()
    }
    
    func modalViewDidShow(withHeight height: CGFloat, customSubview subView: CustomView, andValues values: [Any]?) {
        if (blackoutView == nil) {
            blackoutView = MSMBlackoutView.init(inView: view)
            blackoutView!.didShow()
        }
        
        modalView = ModalView.init(inView: blackoutView!, withHeight: height)
        _ = ConfirmView.init(inView: modalView!)
    }
    
    
    // MARK: - Transition
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        _ = dottedBorderViewsCollection.map { $0.setNeedsDisplay() }
    }

    
    // MARK: - Actions
    @IBAction func handlerConfirmButtonTap(_ sender: FillVeryLightOrangeButton) {
    }
    
    @IBAction func handlerCancelButtonTap(_ sender: BorderVeryLightOrangeButton) {
    }
    
    @IBAction func handlerCheckButtonTap(_ sender: DLRadioButton) {
        sender.tag = (sender.tag == 0) ? 1 : 0
        
        if (sender.tag == 1) {
            sender.isSelected = true
        } else {
            sender.isSelected = false
        }
    }
}


// MARK: - OrderShowViewControllerInput
extension OrderShowViewController: OrderShowViewControllerInput {
    func orderDidShowLoad(fromViewModel viewModel: OrderShowModels.OrderItem.ViewModel) {
        // Check for errors
        guard viewModel.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: {
                self.orderProfileDidShow()
            })
            
            return
        }
        
        self.orderProfileDidShow()
    }
}


// MARK: - UIScrollViewDelegate
extension OrderShowViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.indicatorDidChange(UIColor.veryLightOrange)
    }
}
