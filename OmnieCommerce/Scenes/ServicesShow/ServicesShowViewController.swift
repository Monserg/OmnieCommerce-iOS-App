//
//  ServicesShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 14.04.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol ServicesShowViewControllerInput {}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol ServicesShowViewControllerOutput {}

enum ServicesShowMode {
    case PriceList
    case AllServices
}

class ServicesShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: ServicesShowViewControllerOutput!
    var router: ServicesShowRouter!
    
    var services = [Service]()
    var mode: ServicesShowMode = .AllServices
    
    // Outlets
    @IBOutlet weak var smallTopBarView: SmallTopBarView! {
        didSet {
            smallTopBarView.titleText = ((mode == .AllServices) ? "All services".localized() : "Price List".localized())
        }
    }
    
    @IBOutlet weak var tableView: MSMTableView! {
        didSet {
            tableView.contentInset = UIEdgeInsetsMake((UIApplication.shared.statusBarOrientation.isPortrait) ? -10 : 10, 0, 0, 0)
            tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            var headers = [ExpandedHeaderCell]()
            var priceDataSource = [[Price]]()
            
            // Create sections array
            for service in services.filter({ ($0.prices?.count)! > 0 }) {
                headers.append(ExpandedHeaderCell.init(withName: service.name, inMode: mode))
                
                var prices = [Price]()

                for price in service.prices! {
                    (price as! Price).cellHeight = 44.0
                    (price as! Price).cellIdentifier = "ServicePriceTableViewCell"
                    
                    prices.append(price as! Price)
                }
                
                priceDataSource.append(prices)
            }
            
            // Create MSMTableViewControllerManager
            self.tableView.hasHeaders = true
            self.tableView.headears = headers
            
            let servicesTableManager = MSMTableViewControllerManager.init(withTableView: self.tableView,
                                                                          andSectionsCount: headers.count,
                                                                          andEmptyMessageText: "Services list is empty")
            
            tableView.tableViewControllerManager = servicesTableManager
            tableView.tableViewControllerManager.dataSource = priceDataSource
            
            tableView.reloadData()
            
            // Handler select cell
            tableView.tableViewControllerManager.handlerSelectRowCompletion = { item in
                self.router.navigateToServiceShowScene(withID: (item as! Price).serviceID)
            }
        }
    }
    

    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ServicesShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSettingsDidLoad()
    }
    

    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Config smallTopBarView
        navigationBarView = smallTopBarView
        smallTopBarView.type = "Child"
        haveMenuItem = false
        
        // Handler Back button tap
        smallTopBarView.handlerSendButtonCompletion = { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    // MARK: - Transition
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        smallTopBarView.setNeedsDisplay()
        
        // Album
        if newCollection.verticalSizeClass == .compact {
            tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0)
        } else {
            tableView.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0)
        }
        
        self.view.layoutIfNeeded()
    }
}


// MARK: - ServicesShowViewControllerInput
extension ServicesShowViewController: ServicesShowViewControllerInput {}
