//
//  MSMCollectionViewControllerManager.swift
//  OmnieCommerce
//
//  Created by msm72 on 18.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class MSMCollectionViewControllerManager: BaseViewController {
    // MARK: - Properties
    var sectionsCount = 0
    
    var dataSource: [Any]! {
        didSet {
            _ = dataSource.map {
                let cellIdentifier = ($0 as! InitCellParameters).cellIdentifier
                self.collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
            }
        }
    }
    
    var collectionView: MSMCollectionView!
    
    // Handlers
    var handlerCellSelectCompletion: HandlerPassDataCompletion?
    
    
    // MARK: - Class Initialization
    init(withCollectionView collectionView: MSMCollectionView) {
        super.init(nibName: nil, bundle: Bundle.main)
        
        self.collectionView = collectionView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView!.setScrollIndicatorColor(color: UIColor.veryLightOrange)
    }
}


// MARK: - UICollectionViewDataSource
extension MSMCollectionViewControllerManager: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Return the number of sections
        return sectionsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = (dataSource[indexPath.row] as! InitCellParameters).cellIdentifier
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        let item = dataSource[indexPath.row]
        
        // Config cell
        (cell as! ConfigureCell).setup(withItem: item, andIndexPath: indexPath)
        
        switch cell {
        case cell as CategoryCollectionViewCell:
            print(object: "")
            
        default:
            break
        }
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension MSMCollectionViewControllerManager {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        handlerCellSelectCompletion!(dataSource[indexPath.row])
        self.collectionView.deselectItem(at: indexPath, animated: true)
    }

    /*
    // Specify if the specified item should be highlighted during tracking
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Specify if the specified item should be selected
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
    }
    */
}


// MARK: - UICollectionViewDelegateFlowLayout
extension MSMCollectionViewControllerManager: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellIdentifier = (dataSource[indexPath.row] as! InitCellParameters).cellIdentifier
        
        switch cellIdentifier {
        case "CategoryCollectionViewCell":
            let cellHeight: CGFloat = 102.0 * self.collectionView.heightRatio
            
            return (UIApplication.shared.statusBarOrientation.isPortrait) ? CGSize.init(width: (collectionView.frame.width - 16.0) / 2, height: cellHeight) :
                                                                            CGSize.init(width: (collectionView.frame.width - 16 * 2) / 3, height: cellHeight)
            
        case "CirclePhotoCollectionViewCell":
            let cellHeight: CGFloat = 85.0 * self.collectionView.heightRatio
            return CGSize.init(width: cellHeight, height: cellHeight)

        default:
            break
        }
        
        return CGSize.zero
    }
}
