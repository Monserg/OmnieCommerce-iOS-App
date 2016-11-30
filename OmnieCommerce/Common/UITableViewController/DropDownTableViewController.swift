//
//  DropDownTableViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

class DropDownTableViewController: UITableViewController {
    // MARK: - Properties
    var dataSource = Array<String>()
    var sourceType: DropDownList?
//    var completionHandler: (_ value: String) -> ()?
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Config
        getDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Custom Functions
    func getDataSource() {
        switch sourceType! {
        case .City:
            dataSource = ["Lviv", "Kyiv", "Kharkiv", "Uzgorod", "Vinnitsa", "Khmelnytskyi", "Zhitomir", "Poltava"]

        case .Service:
            dataSource = ["сауны", "салоны красоты", "фитнесс залы", "бассейны"]

        case .Rating:
            dataSource = ["1", "2", "3", "4", "5"]
        }
        
        tableView.reloadData()
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "123") {
            
        }
    }
}


// MARK: - UITableViewDataSource
extension DropDownTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as! DropDownTableViewCell

        cell.nameLabel?.text = dataSource[indexPath.row]
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension DropDownTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.Constants.dropDownCellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        completionHandler(dataSource[indexPath.row])
        
    }
}
