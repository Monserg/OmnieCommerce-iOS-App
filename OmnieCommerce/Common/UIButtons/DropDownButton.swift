//
//  DropDownButton.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

enum DropDownList: String {
    case City               =   "City"
    case Services           =   "Services"
    case Categories         =   "Categories"
}

@IBDesignable class DropDownButton: CustomButton {
    // MARK: - Properties
    var dropDownTableVC: DropDownTableViewController!
    var isDropDownListShow = false
    var dataSource: [DropDownItem]!
    
    @IBInspectable var dropDownList: String?

    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        imageEdgeInsets = UIEdgeInsetsMake(3, bounds.width - 16 - borderWidth, 0, 0)
    }

    
    // MARK: - Custom Functions
    func itemsListDidShow(inView view: UIView) {
        // Create DropDownListView from Nib-file
        let senderFrame                                 =   self.convert(self.frame, to: view)
        dropDownTableVC                                 =   UIStoryboard(name: "DropDown",
                                                                         bundle: nil).instantiateViewController(withIdentifier: "DropDownTableVC") as! DropDownTableViewController
     
        dropDownTableVC.tableView.alpha                 =   0
        dropDownTableVC.sourceType                      =   DropDownList.init(rawValue: dropDownList!)
        dropDownTableVC.dataSource                      =   self.dataSource
        
        let count: CGFloat                              =   (dataSource.count >= 5) ? 5.0 : CGFloat(dataSource.count)
        
        dropDownTableVC.tableView.frame                 =   CGRect.init(x: self.frame.minX + self.superview!.frame.minX,
                                                                        y: senderFrame.minY - self.frame.minY,
                                                                        width: senderFrame.width,
                                                                        height: Config.Constants.dropDownCellHeight * count)

        view.addSubview(dropDownTableVC.tableView)

        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.dropDownTableVC.tableView.transform    =   CGAffineTransform(translationX: 0, y: self.frame.height + 2)
            self.dropDownTableVC.tableView.alpha        =   1
            self.isDropDownListShow                     =   true
        }, completion: nil)
    }
    
    func itemsListDidHide(inView view: UIView) {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.dropDownTableVC.view.transform         =   CGAffineTransform(translationX: 0, y: 0)
            self.dropDownTableVC.view.alpha             =   0
            self.isDropDownListShow                     =   false
        }, completion: { success in
            guard success else {
                return
            }
            
            self.dropDownTableVC.tableView.removeFromSuperview()
        })
    }
    
    func changeTitle(newValue title: String) {
        setAttributedTitle(NSAttributedString(string: title, attributes: UIFont.ubuntuLightVeryLightGray12), for: .normal)
        setAttributedTitle(NSAttributedString(string: title, attributes: UIFont.ubuntuLightVeryLightGray12Alpha30), for: .highlighted)
    }
}
