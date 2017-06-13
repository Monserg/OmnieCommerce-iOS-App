 //
//  BaseViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 10.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import AFNetworking
import Localize_Swift
import SWRevealViewController

class BaseViewController: UIViewController {
    // MARK: - Properties
    var selectedRange: CGRect?
    weak var blackoutView: MSMBlackoutView?
    var navigationBarView: SmallTopBarView?
    let spinner = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
    
    var haveMenuItem = false {
        didSet {
            didApplySlideMenuSettings()
        }
    }
    
    var scrollViewBase: UIScrollView? {
        didSet {
            scrollViewBase!.delegate = self
        }
    }

    var handlerImagePickerControllerCompletion: HandlerImagePickerControllerCompletion?
    var handlerChangeNetworkConnectionStateCompletion: HandlerPassDataCompletion?
    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]")
        
        super.awakeFromNib()
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]. View size = \(view.bounds.size)")
        
        super.viewDidLoad()
        
        // Add Observers
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAction), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAction), name: .UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]")

        super.viewWillAppear(true)
        
        // Set status bar color
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.currentViewController = self
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }

    override func didReceiveMemoryWarning() {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]")
        
        super.didReceiveMemoryWarning()
    }
        
    deinit {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]")
    }
    
    
    // MARK: - Actions
    func handleKeyboardAction(notification: Notification) {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]")
        
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        scrollViewBase?.contentInset = (notification.name == .UIKeyboardWillHide) ? .zero : UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 25, right: 0)

        guard (selectedRange != nil && (keyboardViewEndFrame.contains((selectedRange?.origin)!))) else {
            return
        }

        scrollViewBase?.scrollRectToVisible(selectedRange!, animated: true)
    }
    
    
    // MARK: - Custom Functions
    func navigationBarDidHide() {
        navigationController?.isNavigationBarHidden = true
    }

    private func didApplySlideMenuSettings() {
        // Set background color
        view.backgroundColor = UIColor.veryDarkDesaturatedBlue24
        
        // Delegate
        revealViewController().delegate = self
        
        revealViewController().rearViewRevealWidth = 296
        revealViewController().rearViewRevealDisplacement = 198
        revealViewController().rearViewRevealOverdraw = 0
        
        // Faster slide animation
        revealViewController().toggleAnimationDuration = 0.3
        
        // Simply ease out. No Spring animation.
        revealViewController().toggleAnimationType = .easeOut
        
        // More shadow
        revealViewController().frontViewShadowRadius = 0
        revealViewController().frontViewShadowColor = UIColor.clear
        
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        if (haveMenuItem) {
            navigationBarView!.actionButton.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        }
    }
    
    func didAddTapGestureRecognizer() {
        // For all TopBarView
        let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(BaseViewController.handleTap(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func releasePrint(object: Any) {
        Swift.print(object)
    }
    
    func print(object: Any) {
        #if DEBUG
            Swift.print(object)
        #endif
    }
    
    func spinnerDidStart(_ view: UIView?) {
        self.view.isUserInteractionEnabled = false
        spinner.color = UIColor.veryDarkCyan
        
        (view == nil) ? self.view.addSubview(spinner) : view!.addSubview(spinner)
        (view == nil) ? self.view.bringSubview(toFront: spinner) : view!.bringSubview(toFront: spinner)
        spinner.center = (view == nil) ? self.view.center : view!.center
        spinner.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func spinnerDidFinish() {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.view.isUserInteractionEnabled = true
    }
}


// MARK: - UIScrollViewDelegate
extension BaseViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]. UIScrollView.contentOffset.y = \(scrollView.contentOffset.y)")
        
        scrollView.indicatorDidChange(UIColor.veryLightOrange)
    }
}


// MARK: - UIGestureRecognizerDelegate
extension BaseViewController: UIGestureRecognizerDelegate {
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]")
        
        view.endEditing(true)
    }
}


// MARK: - UINavigationControllerDelegate
extension BaseViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().barTintColor = UIColor.veryDarkGray
        UINavigationBar.appearance().tintColor = UIColor.veryLightGray
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.veryLightGray]
        UINavigationBar.appearance().isTranslucent = false
    }
}


// MARK: - UIImagePickerControllerDelegate
extension BaseViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        dismiss(animated: true, completion: nil)
        handlerImagePickerControllerCompletion!(chosenImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
 
 
// MARK: - SWRevealViewControllerDelegate
extension BaseViewController: SWRevealViewControllerDelegate {
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        view.endEditing(true)
        
        switch position {
        case .right, .rightMost, .rightMostRemoved:
            // Create blackOutView
            blackoutView = MSMBlackoutView.init(inView: view)
            
            let menuButton = UIButton.init(frame: CGRect.init(origin: CGPoint.init(x: 0.0, y: 2.0), size: CGSize.init(width: 50, height: 80)))
            menuButton.setImage(UIImage.init(named: "icon-menu-normal"), for: .normal)
            menuButton.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            blackoutView!.addSubview(menuButton)
            blackoutView!.didShow()
            
        default:
            blackoutView?.removeFromSuperview()
            blackoutView = nil
        }
    }
}
