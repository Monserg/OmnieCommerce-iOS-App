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
import CoreData
import SwiftyVK
import GoogleSignIn
import FBSDKLoginKit

// MARK: - Input & Output protocols
protocol SignInShowViewControllerInput {
    func displaySomething(viewModel: SignInShowModels.User.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol SignInShowViewControllerOutput {
    func didUserSignIn(requestModel: SignInShowModels.User.RequestModel)
}

enum AnimationDirection {
    case FromLeftToRight
    case FromRightToLeft
}

class SignInShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: SignInShowViewControllerOutput!
    var router: SignInShowRouter!
    
    var animationDirection: AnimationDirection?

    // Managers
    var socialNetworkManager: SocialNetworkManager?
    
    // Container childVC
    var signUpShowVC: SignUpShowViewController?
    var signInContainerShowVC: SignInContainerShowViewController?
    var forgotPasswordShowVC: ForgotPasswordShowViewController?
    var enterCodeShowViewController: EnterCodeShowViewController?
    var repetitionPasswordShowViewController: RepetitionPasswordShowViewController?
    
    var activeViewController: BaseViewController? {
        didSet {
            guard oldValue != nil else {
                router.updateActiveViewController()
                
                return
            }
            
            animationDirection = ((oldValue?.view.tag)! < (activeViewController?.view.tag)!) ? .FromRightToLeft : .FromLeftToRight
            router.removeInactiveViewController(inactiveViewController: oldValue)
        }
    }

    @IBOutlet weak var containerView: UIView!
    @IBOutlet var bigTopBarView: BigTopBarView!

    // Social network buttons
    @IBOutlet weak var vkontakteButton: CustomButton!
    @IBOutlet weak var googleButton: CustomButton!
    @IBOutlet weak var facebookButton: CustomButton!

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        SignInShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Config controls
        topBarViewStyle = .Big

        // Set buttons type
        vkontakteButton.designStyle = "Social"
        googleButton.designStyle = "Social"
        facebookButton.designStyle = "Social"
        
        setup(topBarView: bigTopBarView)
        
        doInitialSetupOnLoad()
    }
    
    
    // MARK: - Custom Functions
    func doInitialSetupOnLoad() {
        // Hide navigation bar
        navigationBarDidHide()
        
        // Apply Container childVC
        (CoreDataManager.instance.appUser.isAuthorized) ? router.navigateAuthorizedUser(duringStartApp: true) : router.navigateBetweenContainerSubviews()
    }
    
    func setupScene(withSize size: CGSize) {
        print(object: "\(type(of: self)): \(#function) run. Screen view size = \(size)")

        bigTopBarView.setNeedsDisplay()
        bigTopBarView.circleView.setNeedsDisplay()
        vkontakteButton.setNeedsDisplay()
        googleButton.setNeedsDisplay()
        facebookButton.setNeedsDisplay()
    }
    
    
    // MARK: - Actions
    @IBAction func handlerSignInButtonTap(_ sender: CustomButton) {
        print(object: "\(type(of: self)): \(#function) run.")
    }
    
    @IBAction func handlerSocialNetworkButtonTap(_ sender: CustomButton) {
        guard isNetworkAvailable else {
            alertViewDidShow(withTitle: "Not Reachable".localized(), andMessage: "Disconnected from Network".localized())
            
            return
        }
        
        // Set status bar color
        UIApplication.shared.statusBarStyle = (sender.tag == 0) ? .lightContent : .default
        
        // Only for Google
        if (sender.tag == 1) {
            GIDSignIn.sharedInstance().uiDelegate = self
        }
        
        if (sender.tag == 2) {
            let facebook = FBSDKLoginManager()
            
            facebook.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
                guard result?.token != nil else {
                    return
                }
                
                let fbToken     =   result!.token.tokenString
                let fbUserID    =   result!.token.userID
                
                //            let fbUserEmail = result!.token.
                //            let strFirstName: String = (result.objectForKey("first_name") as? String)!
                //            let strLastName: String = (result.objectForKey("last_name") as? String)!
                //            let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                
                CoreDataManager.instance.didUpdateAppUser(state: true)
                
                self.router.navigateAuthorizedUser(duringStartApp: false)
            }
        } else {
            socialNetworkManager = SocialNetworkManager(withNetwork: sender.tag)
            socialNetworkManager!.didAuthorizeUser()
            
            // Handler Auth successfull request
            socialNetworkManager?.handlerSendButtonCompletion = { _ in
                CoreDataManager.instance.didUpdateAppUser(state: true)

                self.router.navigateAuthorizedUser(duringStartApp: false)
            }
        }
    }

    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(object: "\(type(of: self)): \(#function) run. New size = \(size)")
        
        setupScene(withSize: size)
    }
}


// MARK: - SignInShowViewControllerInput
extension SignInShowViewController: SignInShowViewControllerInput {
    func displaySomething(viewModel: SignInShowModels.User.ViewModel) {
        guard isNetworkAvailable else {
            alertViewDidShow(withTitle: "Not Reachable".localized(), andMessage: "Disconnected from Network".localized())
            
            return
        }
        
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
}


// MARK: - GIDSignInUIDelegate
extension SignInShowViewController: GIDSignInUIDelegate {
    // Stop the UIActivityIndicatorView animation that was started when the user pressed the Sign In button
    private func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        print(object: #function)
    }
    
    // Present a view that prompts the user to sign in with Google
    private func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        print(object: #function)
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    private func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        print(object: #function)
        
        self.dismiss(animated: true, completion: nil)
    }
}
