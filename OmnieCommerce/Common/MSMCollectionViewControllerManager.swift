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
    var dataSource: [Any]! {
        didSet {
            _ = dataSource.map {
                let cellIdentifier = ($0 as! InitCellParameters).cellIdentifier
                self.collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
            }
        }
    }
    
    var collectionView: MSMCollectionView!
    var dataSourceFiltered = [Any]()
    var isSearchBarActive: Bool = false
    var refreshControl: UIRefreshControl?
    var isLoadMore = false
    var sectionsCount = 0
    var emptyText: String!

    // Handlers
    var handlerCellSelectCompletion: HandlerPassDataCompletion?
    var handlerNavigationButtonTapCompletion: HandlerPassDataCompletion?
    var handlerPullRefreshCompletion: HandlerSendButtonCompletion?
    var handlerInfiniteScrollCompletion: HandlerSendButtonCompletion?

    
    // MARK: - Class Initialization
    init(withCollectionView collectionView: MSMCollectionView, andEmptyMessageText text: String) {
        super.init(nibName: nil, bundle: Bundle.main)
        
        self.collectionView = collectionView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.emptyText = text
        
        self.pullRefreshDidCreate()
    }

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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]. UIScrollView.contentOffset.y = \(scrollView.contentOffset.y)")
        
        collectionView!.setScrollIndicatorColor(color: UIColor.veryLightOrange)
        
        // Set Infinite Scroll
        guard isNetworkAvailable else {
            return
        }
        
//        if (!self.collectionView!.hasHeaders && (self.dataSource.count + self.dataSourceFiltered.count > 0)) {
//            if (scrollView.contentOffset.y >= footerViewHeight && !isLoadMore) {
//                isLoadMore = !isLoadMore
//                
//                // Refresh FooterView
//                self.collectionView!.beginUpdates()
//                
//                (self.collectionView!.tableFooterView as! MSMTableViewFooterView).didUpload(forItemsCount: dataSource.count,
//                                                                                       andEmptyText: emptyText)
//                
//                self.tableView!.endUpdates()
//                
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//                    self.handlerInfiniteScrollCompletion!()
//                }
//            }
//        }
    }

    
    // MARK: - Custom Functions
    private func pullRefreshDidCreate() {
        if (!collectionView!.hasHeaders) {
            refreshControl = UIRefreshControl()
            refreshControl!.tintColor = UIColor.init(hexString: "#dedede", withAlpha: 1.0)
            refreshControl!.attributedTitle = NSAttributedString(string: "Loading Data".localized(),
                                                                 attributes: [NSFontAttributeName:  UIFont(name: "Ubuntu-Light", size: 12.0)!,
                                                                              NSForegroundColorAttributeName: UIColor.veryLightGray])
            
            if #available(iOS 10.0, *) {
                collectionView!.refreshControl = refreshControl!
            } else {
                collectionView!.addSubview(refreshControl!)
            }
            
            refreshControl!.addTarget(self, action: #selector(handlerPullRefresh), for: .valueChanged)
        }
    }
    
    func pullRefreshDidFinish() {
        refreshControl!.endRefreshing()
        isLoadMore = false
    }
    
    func handlerPullRefresh(refreshControl: UIRefreshControl) {
        guard isNetworkAvailable else {
            refreshControl.endRefreshing()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.handlerPullRefreshCompletion!()
        }
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
            
        case cell as ReviewCollectionViewCell:
            // Handler tap on data source navigation buttons
            (cell as! ReviewCollectionViewCell).handlerPageButtonTapCompletion = { button in
                var item = indexPath.row
                
                if ((button as! UIButton).tag == 0) {
                    item = (item == 0) ? (self.dataSource.count - 1) : (item - 1)
                } else {
                    item = (item == self.dataSource.count - 1) ? 0 : (item + 1)
                }
                
                self.handlerNavigationButtonTapCompletion!(item)
            }
        
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
}


// MARK: - UICollectionViewDelegateFlowLayout
extension MSMCollectionViewControllerManager: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellIdentifier = (dataSource[indexPath.row] as! InitCellParameters).cellIdentifier
        let cellHeight = (dataSource[indexPath.row] as! InitCellParameters).cellHeight
        
        switch cellIdentifier {
        case "CategoryCollectionViewCell":
            let height: CGFloat = cellHeight * self.collectionView.heightRatio
            
            return (UIApplication.shared.statusBarOrientation.isPortrait) ? CGSize.init(width: (collectionView.frame.width - 16.0) / 2, height: height) :
                                                                            CGSize.init(width: (collectionView.frame.width - 16 * 2) / 3, height: height)

        case "DiscountCardCollectionViewCell":
            let height: CGFloat = cellHeight * self.collectionView.heightRatio
            let width: CGFloat = ((UIApplication.shared.statusBarOrientation.isLandscape) ? CGFloat(520.0) : UIScreen.main.bounds.width - 16.0) * self.collectionView.widthRatio
            
            return (UIApplication.shared.statusBarOrientation.isPortrait) ? CGSize.init(width: (width - 39.0) / 2, height: height) :
                                                                            CGSize.init(width: (width - 20.0 * 2) / 3, height: height)

        case "CirclePhotoCollectionViewCell":
            let height: CGFloat = cellHeight * self.collectionView.heightRatio
            return CGSize.init(width: height, height: height)

        case "ReviewCollectionViewCell":
            return collectionView.frame.size
            
        default:
            break
        }
        
        return CGSize.zero
    }
}
