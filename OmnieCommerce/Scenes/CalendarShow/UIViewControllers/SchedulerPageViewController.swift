//
//  SchedulerPageViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 20.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

class SchedulerPageViewController: UIPageViewController {
    // MARK: - Properties
    let schedulerVC = UIStoryboard.init(name: "CalendarShow", bundle: nil).instantiateViewController(withIdentifier: "SchedulerVC") as! SchedulerViewController
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegates
        self.dataSource = self
        
        self.setViewControllers([getContentViewControllerAtIndex(367)] as [SchedulerViewController], direction: .forward, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Custom Functions
    func getContentViewControllerAtIndex(_ index: NSInteger) -> SchedulerViewController {
        schedulerVC.pageIndex = index
        
        return schedulerVC
    }

    
    // MARK: - Actions
    @IBAction func handlerNextButtonForUnwind(_ segue: UIStoryboardSegue) {
        var index = schedulerVC.pageIndex
        
        guard (index != NSNotFound) else {
            return
        }
        
        index += 1
        
        // Add 1 year from current date
        guard (index != 367 + 366) else {
            return
        }
        
        self.setViewControllers([getContentViewControllerAtIndex(index)] as [SchedulerViewController], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func handlerPreviousButtonForUnwind(_ segue: UIStoryboardSegue) {
        var index = schedulerVC.pageIndex
        
        guard ((index != 0) || (index != NSNotFound)) else {
            return
        }
        
        index -= 1
        
        self.setViewControllers([getContentViewControllerAtIndex(index)] as [SchedulerViewController], direction: .forward, animated: true, completion: nil)
    }
}


// MARK: - UIPageViewControllerDataSource
extension SchedulerPageViewController: UIPageViewControllerDataSource {
    // Previous date
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = schedulerVC.pageIndex
        
        if ((index == 0) || (index == NSNotFound)) {
            return nil
        }
        
        index -= 1
        
        return getContentViewControllerAtIndex(index)
    }
    
    // Next date
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = schedulerVC.pageIndex
        
        if (index == NSNotFound) {
            return nil
        }
        
        index += 1
        
        // Add 1 year from current date
        if (index == 367 + 366) {
            return nil
        }
        
        return getContentViewControllerAtIndex(index)
    }
}
