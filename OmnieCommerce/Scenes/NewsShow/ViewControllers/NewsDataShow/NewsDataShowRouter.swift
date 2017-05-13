//
//  NewsDataShowRouter.swift
//  OmnieCommerce
//
//  Created by msm72 on 31.03.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input & Output protocols
protocol NewsDataShowRouterInput {
    func navigateToSomewhere()
    func navigateToNewsItemShowScene(_ item: NewsData)
}

class NewsDataShowRouter: NewsDataShowRouterInput {
    // MARK: - Properties
    weak var viewController: NewsDataShowViewController!
    
    
    // MARK: - Custom Functions. Navigation
    func navigateToNewsItemShowScene(_ item: NewsData) {
        // Get full info about NewsData by ID
        guard isNetworkAvailable else {
            let storyboard = UIStoryboard(name: "NewsShow", bundle: nil)
            let newsItemShowVC = storyboard.instantiateViewController(withIdentifier: "NewsItemShowVC") as! NewsItemShowViewController
            newsItemShowVC.newsItem = item
            
            self.viewController.navigationController?.pushViewController(newsItemShowVC, animated: true)
            return
        }
        
        MSMRestApiManager.instance.userRequestDidRun(.userGetNewsDataByID(["id": item.codeID], false), withHandlerResponseAPICompletion: { responseAPI in
            // Check for errors
            guard responseAPI?.code == 200 else {
                self.viewController.alertViewDidShow(withTitle: "Error", andMessage: String(responseAPI!.status), completion: { _ in })
                return
            }
            
            // Create News
            let _ = NewsData.init(json: responseAPI!.body as! [String: AnyObject], isAction: false)
            let storyboard = UIStoryboard(name: "NewsShow", bundle: nil)
            let newsItemShowVC = storyboard.instantiateViewController(withIdentifier: "NewsItemShowVC") as! NewsItemShowViewController
            newsItemShowVC.newsItem = CoreDataManager.instance.entityDidLoad(byName: "NewsData", andPredicateParameter: item.codeID) as! NewsData
            
            self.viewController.navigationController?.pushViewController(newsItemShowVC, animated: true)
        })
    }

    func navigateToSomewhere() {
        // NOTE: Teach the router how to navigate to another scene. Some examples follow:
        // 1. Trigger a storyboard segue
        // viewController.performSegueWithIdentifier("ShowSomewhereScene", sender: nil)
        
        // 2. Present another view controller programmatically
        // viewController.presentViewController(someWhereViewController, animated: true, completion: nil)
        
        // 3. Ask the navigation controller to push another view controller onto the stack
        // viewController.navigationController?.pushViewController(someWhereViewController, animated: true)
        
        // 4. Present a view controller from a different storyboard
        // let storyboard = UIStoryboard(name: "OtherThanMain", bundle: nil)
        // let someWhereViewController = storyboard.instantiateInitialViewController() as! SomeWhereViewController
        // viewController.navigationController?.pushViewController(someWhereViewController, animated: true)
    }
    
    // Communication
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with
        if segue.identifier == "ShowSomewhereScene" {
            passDataToSomewhereScene(segue: segue)
        }
    }
    
    // Transition
    func passDataToSomewhereScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router how to pass data to the next scene
        // let someWhereViewController = segue.destinationViewController as! SomeWhereViewController
        // someWhereViewController.output.name = viewController.output.name
    }
}
