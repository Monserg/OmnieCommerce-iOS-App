//
//  OmnieCardsShowViewController.swift
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
protocol OmnieCardsShowViewControllerInput {
    func displaySomething(viewModel: OmnieCardsShow.Something.ViewModel)
}

protocol OmnieCardsShowViewControllerOutput {
    func doSomething(request: OmnieCardsShow.Something.Request)
}

class OmnieCardsShowViewController: BaseViewController, OmnieCardsShowViewControllerInput {
    // MARK: - Properties
    var output: OmnieCardsShowViewControllerOutput!
    var router: OmnieCardsShowRouter!
    let barcodeViewModel = OmnieCardViewModel()
    
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet weak var copyrightLabel: CustomLabel!
    @IBOutlet weak var barcodeView: BarCodeView!

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        OmnieCardsShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Config topBarView
        smallTopBarView.type = "ParentSearch"
        topBarViewStyle = .Small
        smallTopBarView.searchButton.isHidden = true
        setup(topBarView: smallTopBarView)

        initialSetupDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        barcodeView.titleLabel.text = barcodeViewModel.getBarCodeID()
        barcodeView.imageView.image = barcodeViewModel.createBarCode()
    }

    // MARK: - Custom Functions
    func initialSetupDidLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // NOTE: Ask the Interactor to do some work
        let request = OmnieCardsShow.Something.Request()
        output.doSomething(request: request)
    }
    
    // Display logic
    func displaySomething(viewModel: OmnieCardsShow.Something.ViewModel) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
    
    func setupScene(withSize size: CGSize) {
        print(object: "\(type(of: self)): \(#function) run. Screen view size = \(size)")
        
        smallTopBarView.setNeedsDisplay()
        smallTopBarView.circleView.setNeedsDisplay()
    }
    
    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(object: "\(type(of: self)): \(#function) run. New size = \(size)")
        
        setupScene(withSize: size)
    }
}
