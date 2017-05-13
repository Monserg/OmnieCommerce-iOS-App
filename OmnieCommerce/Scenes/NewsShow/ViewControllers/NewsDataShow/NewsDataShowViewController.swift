//
//  NewsDataShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 31.03.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol NewsDataShowViewControllerInput {
    func newsDataDidShowLoad(fromViewModel viewModel: NewsDataShowModels.Data.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol NewsDataShowViewControllerOutput {
    func newsDataDidLoad(withRequestModel requestModel: NewsDataShowModels.Data.RequestModel)
}

class NewsDataShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: NewsDataShowViewControllerOutput!
    var router: NewsDataShowRouter!
    
    var newsData = [NewsData]()
    var limit: Int!

    @IBOutlet weak var tableView: MSMTableView! {
        didSet {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }

    
    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NewsDataShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create MSMTableViewControllerManager
        let newsDataTableManager = MSMTableViewControllerManager.init(withTableView: self.tableView,
                                                                      andSectionsCount: 1,
                                                                      andEmptyMessageText: "NewsData list is empty")
        
        tableView.tableViewControllerManager = newsDataTableManager
        
        limit = (newsData.count == 0) ? Config.Constants.paginationLimit : newsData.count
        viewSettingsDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    

    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Load NewsData list from CoreData
        guard isNetworkAvailable else {
            newsDataListDidShow()
            return
        }
        
        // Load NewsData list from API
        if (isNetworkAvailable) {
            newsData = [NewsData]()
            CoreDataManager.instance.entitiesDidRemove(byName: "Lists", andPredicateParameters: NSPredicate(format: "name == %@", keyNewsData))
            newsDataListDidLoad(withOffset: 0, scrollingData: false)
        } else {
            spinnerDidFinish()
        }
    }
    
    func newsDataListDidLoad(withOffset offset: Int, scrollingData: Bool) {
        guard isNetworkAvailable else {
            self.newsDataListDidShow()
            return
        }
        
        if (!scrollingData) {
            spinnerDidStart(view)
        }
        
        let bodyParameters: [String: Any] = [ "limit": limit, "offset": offset ]
        let newsDataRequestModel = NewsDataShowModels.Data.RequestModel(parameters: bodyParameters)
        interactor.newsDataDidLoad(withRequestModel: newsDataRequestModel)
    }
    
    func newsDataListDidShow() {
        // Setting MSMTableViewControllerManager
        let newsLists = CoreDataManager.instance.entitiesDidLoad(byName: "NewsData",
                                                                 andPredicateParameters: NSPredicate(format: "newsList.name == %@", keyNewsData))
        
        if let news = newsLists as? [NewsData] {
            newsData = news
            tableView.tableViewControllerManager!.dataSource = news
            tableView!.tableFooterView!.isHidden = (news.count > 0) ? true : false
            
            (tableView!.tableFooterView as! MSMTableViewFooterView).didUpload(forItemsCount: news.count,
                                                                              andEmptyText: "NewsData list is empty")
            
            tableView.reloadData()
        }
        
        // Handler select cell
        tableView.tableViewControllerManager!.handlerSelectRowCompletion = { newsData in
            self.router.navigateToNewsItemShowScene(newsData as! NewsData)
        }
        
        // Handler PullRefresh
        tableView.tableViewControllerManager!.handlerPullRefreshCompletion = { _ in
            // Reload NewsData list from API
            self.newsData = [NewsData]()
            CoreDataManager.instance.entitiesDidRemove(byName: "Lists", andPredicateParameters: NSPredicate(format: "name == %@", keyNewsData))
            self.newsDataListDidLoad(withOffset: 0, scrollingData: true)
        }
        
        // Handler InfiniteScroll
        tableView.tableViewControllerManager.handlerInfiniteScrollCompletion = { _ in
            // Load More NewsData from API
            self.newsDataListDidLoad(withOffset: self.newsData.count, scrollingData: true)
        }
        
        tableView.tableViewControllerManager.pullRefreshDidFinish()
        spinnerDidFinish()
    }
}


// MARK: - NewsDataShowViewControllerInput
extension NewsDataShowViewController: NewsDataShowViewControllerInput {
    func newsDataDidShowLoad(fromViewModel viewModel: NewsDataShowModels.Data.ViewModel) {
        // Check for errors
        guard viewModel.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: {
                self.newsDataListDidShow()
            })
            
            return
        }
        
        self.newsDataListDidShow()
    }
}
