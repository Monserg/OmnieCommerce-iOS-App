//
//  CategoriesShowViewController.swift
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
protocol CategoriesShowViewControllerInput {
    func displaySomething(viewModel: CategoriesShow.Something.ViewModel)
}

protocol CategoriesShowViewControllerOutput {
    func doSomething(request: CategoriesShow.Something.Request)
}

class CategoriesShowViewController: BaseViewController, CategoriesShowViewControllerInput {
    // MARK: - Properties
    var output: CategoriesShowViewControllerOutput!
    var router: CategoriesShowRouter!
    
    var dataSource = [ "Auto Service", "Health", "Beauty", "Training", "Restaurants", "Tourism", "Sport" ]
    
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet weak var copyrightLabel: CustomLabel!
    @IBOutlet weak var collectionView: UICollectionView!

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CategoriesShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Config topBarView
        smallTopBarView.type = "ParentSearch"
        topBarViewStyle = .Small
        setup(topBarView: smallTopBarView)

        doSomethingOnLoad()
    }
    

    // MARK: - Custom Functions
    func doSomethingOnLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // NOTE: Ask the Interactor to do some work
        let request = CategoriesShow.Something.Request()
        output.doSomething(request: request)
    }
    
    // Display logic
    func displaySomething(viewModel: CategoriesShow.Something.ViewModel) {
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


// MARK: - UICollectionViewDataSource
extension CategoriesShowViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CustomCollectionViewCell

        cell.backgroundColor = Config.Colors.veryLightOrange

        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension CategoriesShowViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension CategoriesShowViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return (UIApplication.shared.statusBarOrientation.isPortrait) ? CGSize.init(width: (collectionView.frame.width - 16.0) / 2, height: 102) : CGSize.init(width: (collectionView.frame.width - 16 * 2) / 3, height: 102)
    }
}
