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

// MARK: - Input & Output protocols
protocol FavoriteShowViewControllerInput {
    func displaySomething(viewModel: FavoriteShow.Something.ViewModel)
}

protocol FavoriteShowViewControllerOutput {
    func doSomething(request: FavoriteShow.Something.Request)
}

class FavoriteShowViewController: BaseViewController {
    // MARK: - Properties
    var output: FavoriteShowViewControllerOutput!
    var router: FavoriteShowRouter!
    
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet weak var copyrightLabel: CustomLabel!
    @IBOutlet weak var segmentedControlView: SegmentedControlView!
    
    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        FavoriteShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Config topBarView
        smallTopBarView.type    =   "ParentSearch"
        topBarViewStyle         =   .Small
        setup(topBarView: smallTopBarView)

        viewSettingsDidLoad()
    }

    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        setupSegmentedControlView()

        // NOTE: Ask the Interactor to do some work
        let request = FavoriteShow.Something.Request()
        output.doSomething(request: request)
    }
    
    func setupSegmentedControlView() {
        segmentedControlView.backgroundColor = UIColor.veryDarkDesaturatedBlue24
        
        segmentedControlView.actionButtonHandlerCompletion  =   { sender in
//            self.print(object: "\(type(of: self)): \(#function) run. Sender tag = \(sender.tag)")
        }
    }

    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(object: "\(type(of: self)): \(#function) run. New size = \(size)")
        
        smallTopBarView.setNeedsDisplay()
        smallTopBarView.circleView.setNeedsDisplay()
    }
}


// MARK: - 
extension FavoriteShowViewController: FavoriteShowViewControllerInput {
    func displaySomething(viewModel: FavoriteShow.Something.ViewModel) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
}
