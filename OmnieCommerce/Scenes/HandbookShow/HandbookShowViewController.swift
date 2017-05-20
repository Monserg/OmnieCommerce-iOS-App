//
//  HandbookShowViewController.swift
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
protocol HandbookShowViewControllerInput {
    func displaySomething(viewModel: HandbookShow.Something.ViewModel)
}

protocol HandbookShowViewControllerOutput {
    func doSomething(request: HandbookShow.Something.Request)
}

class HandbookShowViewController: BaseViewController {
    // MARK: - Properties
    var output: HandbookShowViewControllerOutput!
    var router: HandbookShowRouter!
    
    // nil = create mode
    var handbookID: String?
    
    // Outlets
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    
    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        HandbookShowConfigurator.sharedInstance.configure(viewController: self)
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSettingsDidLoad()
    }
    
    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // Config smallTopBarView
        navigationBarView = smallTopBarView
        smallTopBarView.type = "Child"
        haveMenuItem = false
        
        // Handler Back button tap
        smallTopBarView.handlerSendButtonCompletion = { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }

        let handbookProfile: Handbook? = (handbookID == nil) ? nil : CoreDataManager.instance.entityDidLoad(byName: "Handbook", andPredicateParameters: NSPredicate.init(format: "codeID == %@", self.handbookID!)) as? Handbook
        
        if let handbook = handbookProfile {
            // Show scene
            
        }
    }
    
    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(object: "\(type(of: self)): \(#function) run. New size = \(size)")
        
        smallTopBarView.setNeedsDisplay()
        smallTopBarView.circleView.setNeedsDisplay()
    }
}


// MARK: - HandbookShowViewControllerInput
extension HandbookShowViewController: HandbookShowViewControllerInput {
    func displaySomething(viewModel: HandbookShow.Something.ViewModel) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
}
