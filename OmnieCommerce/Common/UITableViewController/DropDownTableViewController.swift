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
    var dataSource = Array<DropDownFilterList>()
    var sourceType: DropDownList!
    var completionHandler: ((_ value: DropDownFilterList) -> ())?
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

        switch sourceType! {
        case .City:
            cell.didSetup(withCity: dataSource[indexPath.row] as! City)
        
        case .Service:
            cell.didSetup(withCity: dataSource[indexPath.row] as! City)

        case .Rating:
            cell.didSetup(withCity: dataSource[indexPath.row] as! City)
        }
        
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
        
        completionHandler!(dataSource[indexPath.row])        
    }
}
