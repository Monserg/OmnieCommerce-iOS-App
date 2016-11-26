//
//  SignInShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input & Output protocols
protocol SignInShowViewControllerInput {
    func displaySomething(viewModel: SignInShow.Something.ViewModel)
}

protocol SignInShowViewControllerOutput {
    func doSomething(request: SignInShow.Something.Request)
}

class SignInShowViewController: BaseViewController, SignInShowViewControllerInput {
    // MARK: - Properties
    var output: SignInShowViewControllerOutput!
    var router: SignInShowRouter!
    
    @IBOutlet var bigTopBarView: BigTopBarView!
    @IBOutlet weak var scrollView: UIScrollView!
///    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!

    
//    @IBOutlet weak var vkontakteButton: UIButton!
//    @IBOutlet weak var googleButton: UIButton!
//    @IBOutlet weak var facebookButton: UIButton!
//    

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        SignInShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBarViewStyle = .Big
        
        // Delegates
        scrollView.delegate = self
        nameTextField.delegate = self
        passwordTextField.delegate = self
        
        scrollViewBase = scrollView
        
        
        
        // Set buttons type
//        vkontakteButton.type = .social
//        googleButton.type = .social
//        facebookButton.type = .social
        
        
        setup(topBarView: bigTopBarView)
        
        doSomethingOnLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()    
    }

    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(object: "\(type(of: self)): \(#function) run. New size = \(size)")
        
        setupScene(withSize: size)
    }
    
    
    // MARK: - Actions
    @IBAction func asdasdasd(_ sender: UIButton) {
        print(object: "\(type(of: self)): \(#function) run.")

        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Custom Functions
    func doSomethingOnLoad() {
        print(object: "\(type(of: self)): \(#function) run.")

        // NOTE: Ask the Interactor to do some work
        let request = SignInShow.Something.Request()
        output.doSomething(request: request)
    }
    
    // Display logic
    func displaySomething(viewModel: SignInShow.Something.ViewModel) {
        print(object: "\(type(of: self)): \(#function) run.")

        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
    
    func setupScene(withSize size: CGSize) {
        print(object: "\(type(of: self)): \(#function) run. Screen view size = \(size)")

        bigTopBarView.setNeedsDisplay()
        bigTopBarView.circleView.setNeedsDisplay()
        
        
        //        if (topBarView.circleView.cirleRadiusStyle == .small) {
        //            vkontakteButton.setNeedsDisplay()
        //            googleButton.setNeedsDisplay()
        //            facebookButton.setNeedsDisplay()
        //        } else {
        //            vkontakteButton.isHidden = true
        //            googleButton.isHidden = true
        //            facebookButton.isHidden = true
        //        }
    }
}
