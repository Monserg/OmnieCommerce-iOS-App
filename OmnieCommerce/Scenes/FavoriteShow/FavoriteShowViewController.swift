//
//  FavoriteShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 09.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol FavoriteShowViewControllerInput {
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol FavoriteShowViewControllerOutput {
}

class FavoriteShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: FavoriteShowViewControllerOutput!
    var router: FavoriteShowRouter!
    
    // Container childVC
    var animationDirection: AnimationDirection?
    var favoriteServicesVC: FavoriteServicesShowViewController?
    var favoriteOrganizationsVC: FavoriteOrganizationsShowViewController?
    
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
    
    @IBOutlet weak var copyrightLabel: CustomLabel!
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet weak var segmentedControlView: SegmentedControlView!
    @IBOutlet weak var containerView: CustomView!

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        FavoriteShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Container Child Views
        favoriteOrganizationsVC  = UIStoryboard(name: "FavoriteShow", bundle: nil).instantiateViewController(withIdentifier: "FavoriteOrganizationsShowVC") as? FavoriteOrganizationsShowViewController
        
        favoriteServicesVC = UIStoryboard(name: "FavoriteShow", bundle: nil).instantiateViewController(withIdentifier: "FavoriteServicesShowVC") as? FavoriteServicesShowViewController

        activeViewController = favoriteOrganizationsVC
        
        viewSettingsDidLoad()
    }

    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // Config smallTopBarView
        navigationBarView = smallTopBarView
        smallTopBarView.type = "Parent"
        haveMenuItem = true
        
        setupSegmentedControlView()
        containerView.autoresizesSubviews = true
    }
    
    func setupSegmentedControlView() {
        segmentedControlView.backgroundColor = UIColor.veryDarkDesaturatedBlue24
        
        segmentedControlView.actionButtonHandlerCompletion = { sender in
            switch sender.tag {
            case 1:
                self.activeViewController = self.favoriteServicesVC
                
            default:
                self.activeViewController = self.favoriteOrganizationsVC
            }
        }
    }

    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(object: "\(type(of: self)): \(#function) run. New size = \(size)")
        
        smallTopBarView.setNeedsDisplay()
        smallTopBarView.circleView.setNeedsDisplay()
        segmentedControlView.setNeedsDisplay()

        _ = favoriteOrganizationsVC!.tableView.visibleCells.map { ($0 as! DottedBorderViewBinding).dottedBorderView.setNeedsDisplay() }
        
        if (favoriteServicesVC!.tableView != nil) {
            _ = favoriteServicesVC!.tableView.visibleCells.map { ($0 as! DottedBorderViewBinding).dottedBorderView.setNeedsDisplay() }
        }
    }
}


// MARK: - FavoriteShowViewControllerInput
extension FavoriteShowViewController: FavoriteShowViewControllerInput {}
