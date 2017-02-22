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

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol CategoriesShowViewControllerInput {
    func dataSourceDidShow(fromViewModel viewModel: CategoriesShowModels.Data.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol CategoriesShowViewControllerOutput {
    func dataSourceDidLoad(withRequestModel requestModel: CategoriesShowModels.Data.RequestModel)
}

class CategoriesShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: CategoriesShowViewControllerOutput!
    var router: CategoriesShowRouter!
    
    var dataSource = Array<Category>()
    
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet weak var copyrightLabel: CustomLabel!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var addButton: CustomButton!

    @IBOutlet weak var cityButton: DropDownButton!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            // Delegates
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CategoriesShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Config topBarView
        smallTopBarView.type    =   "ParentSearch"
        topBarViewStyle         =   .Small
        setup(topBarView: smallTopBarView)

        doSomethingOnLoad()
    }
    

    // MARK: - Custom Functions
    func doSomethingOnLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // Get dataSource
        let requestModel = CategoriesShowModels.Data.RequestModel()
        interactor.dataSourceDidLoad(withRequestModel: requestModel)
    }
    
    func setupScene(withSize size: CGSize) {
        print(object: "\(type(of: self)): \(#function) run. Screen view size = \(size)")
        
        smallTopBarView.setNeedsDisplay()
        smallTopBarView.circleView.setNeedsDisplay()
        cityButton.setNeedsDisplay()
        collectionView!.collectionViewLayout.invalidateLayout()
    }
    
    
    // MARK: - Actions
    @IBAction func handlerCityButtonTap(_ sender: DropDownButton) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        (sender.isDropDownListShow) ? sender.hideList(fromView: view) : sender.showList(inView: view)        
        (sender.dropDownTableVC.tableView as! CustomTableView).setScrollIndicatorColor(color: UIColor.veryLightOrange)
        
        // Handler DropDownList selection
        sender.dropDownTableVC.completionHandler = ({ selectedValue in
            sender.changeTitle(newValue: selectedValue)
            
            sender.hideList(fromView: self.view)
        })
    }
    
    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(object: "\(type(of: self)): \(#function) run. New size = \(size)")
        
        setupScene(withSize: size)
        
        if (cityButton.isDropDownListShow) {
            cityButton.hideList(fromView: view)
        }
    }
}


// MARK: - CategoriesShowViewControllerInput
extension CategoriesShowViewController: CategoriesShowViewControllerInput {
    func dataSourceDidShow(fromViewModel viewModel: CategoriesShowModels.Data.ViewModel) {
        self.dataSource = viewModel.dataSource
        
        self.collectionView.reloadData()
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
        let category = dataSource[indexPath.row] as Category
        
        cell.imageView.image = UIImage.init(named: category.icon)
        cell.name.text = category.title
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension CategoriesShowViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        if (cityButton.isDropDownListShow) {
            cityButton.hideList(fromView: view)
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension CategoriesShowViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return (UIApplication.shared.statusBarOrientation.isPortrait) ? CGSize.init(width: (collectionView.frame.width - 16.0) / 2, height: 102) : CGSize.init(width: (collectionView.frame.width - 16 * 2) / 3, height: 102)
    }
}
