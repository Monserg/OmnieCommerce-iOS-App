//
//  PersonalDataViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class PersonalDataViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        didSetupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Custom Functions
    func didSetupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}


// MARK: - UITableViewDataSource
extension PersonalDataViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) //as UITableViewCell
        
        if cell == nil {
            cell = UINib(nibName: cellIdentifier, bundle: nil).instantiate(withOwner: nil, options: nil).first as! UITableViewCell?
        }
        
        return cell!
    }
}


// MARK: - UITableViewDelegate
extension PersonalDataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
}
