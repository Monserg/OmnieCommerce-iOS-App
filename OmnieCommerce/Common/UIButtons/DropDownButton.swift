//
//  DropDownButton.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

enum DropDownList: String {
    case City = "City"
    case Service = "Service"
    case Rating = "Rating"
}

@IBDesignable class DropDownButton: CustomButton {
    // MARK: - Properties
    @IBInspectable var dropDownList: String?

    var dropDownTableVC: DropDownTableViewController!
    var isDropDownListShow = false
    
    
    // MARK: - Custom Functions
    func showList(inView view: UIView) {
        // Create DropDownListView from Nib-file
        let senderFrame = self.convert(self.frame, to: view)
        dropDownTableVC = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "DropDownTableVC") as! DropDownTableViewController
     
        dropDownTableVC.sourceType = DropDownList.init(rawValue: dropDownList!)
        dropDownTableVC.tableView.frame = CGRect.init(x: self.frame.minX, y: senderFrame.minY, width: senderFrame.width, height: Config.Constants.dropDownCellHeight * 5)
        dropDownTableVC.tableView.alpha = 0
        view.addSubview(dropDownTableVC.tableView)
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            var viewFrame = self.dropDownTableVC.tableView.frame
            viewFrame = CGRect.init(x: self.frame.minX, y: senderFrame.maxY - self.frame.minY + 2, width: senderFrame.size.width, height: viewFrame.size.height)
            self.dropDownTableVC.tableView.frame = viewFrame
            self.dropDownTableVC.tableView.alpha = 1
            self.isDropDownListShow = true
        }, completion: nil)
    }
    
    func hideList(fromView view: UIView) {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            let senderFrame = self.convert(self.frame, to: view)
            var viewFrame = self.dropDownTableVC.view.frame
            viewFrame = CGRect.init(x: 8, y: senderFrame.minY, width: senderFrame.size.width, height: viewFrame.size.height)
            self.dropDownTableVC.view.frame = viewFrame
            self.dropDownTableVC.view.alpha = 0
            self.isDropDownListShow = false
        }, completion: { success in
            guard success else {
                return
            }
            
            self.dropDownTableVC.tableView.removeFromSuperview()
        })
    }
    
    func changeTitle(newValue title: String) {
        setAttributedTitle(NSAttributedString(string: title, attributes: Config.Fonts.ubuntuLightVeryLightGray12), for: .normal)
        setAttributedTitle(NSAttributedString(string: title, attributes: Config.Fonts.ubuntuLightVeryLightGray12Alpha30), for: .highlighted)
    }
}
