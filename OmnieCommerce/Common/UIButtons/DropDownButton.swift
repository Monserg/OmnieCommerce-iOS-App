//
//  DropDownButton.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class DropDownButton: CustomButton {
    // MARK: - Properties
    var isDropDownListShow = false
    
    
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
    func itemsListDidShow(_ itemListView: MSMTableView, inView view: UIView) {
        // Create DropDownListView from Nib-file
        let senderFrame = self.convert(self.frame, to: view)
        let count: CGFloat = (itemListView.tableViewControllerManager!.dataSource!.count >= 5) ? 5.0 : CGFloat(itemListView.tableViewControllerManager!.dataSource!.count)
        
        itemListView.frame = CGRect.init(x: self.frame.minX + self.superview!.frame.minX,
                                         y: senderFrame.minY - self.frame.minY,
                                         width: senderFrame.width,
                                         height: Config.Constants.dropDownCellHeight * count)

        itemListView.layer.cornerRadius = 5
        itemListView.layer.borderWidth = 1
        itemListView.layer.borderColor = UIColor.init(hexString: "#009395", withAlpha: 1.0)?.cgColor
        itemListView.clipsToBounds = true
        itemListView.backgroundColor = UIColor.init(hexString: "#24323f", withAlpha: 1.0)
        
        view.addSubview(itemListView)

        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            itemListView.transform = CGAffineTransform(translationX: 0, y: self.frame.height + 2)
            itemListView.alpha = 1
            self.isDropDownListShow = true
        })
    }
    
    func itemsListDidHide(_ itemListView: MSMTableView, inView view: UIView) {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            itemListView.transform = CGAffineTransform(translationX: 0, y: 0)
            itemListView.alpha = 0
            self.isDropDownListShow = false
        }, completion: { success in
            guard success else {
                return
            }
            
            itemListView.removeFromSuperview()
        })
    }
    
    func changeTitle(newValue title: String) {
        setAttributedTitle(NSAttributedString(string: title, attributes: UIFont.ubuntuLightVeryLightGray12), for: .normal)
        setAttributedTitle(NSAttributedString(string: title, attributes: UIFont.ubuntuLightVeryLightGray12Alpha30), for: .highlighted)
    }
}
