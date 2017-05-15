//
//  MenuViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 10.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

class MenuViewCell: UITableViewCell {
    // MARK: - Properties
    typealias CompletionVoid = ((_ sender: UITableViewCell) -> ())

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var newEventButton: CustomButton!
    
    var segueName = String()
    var newEventButtonHandlerCompletion: CompletionVoid?
    
    
    // MARK: - Class Initialization
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    
    // MARK: - Custom Functions
    func setup(menuItem: NSDictionary) {
        self.backgroundColor            =   UIColor.veryDarkDesaturatedBlue25Alpha1
        titleLabel.text                 =   (menuItem.object(forKey: "name") as! String).localized()
        segueName                       =   (menuItem.object(forKey: "segue") as! String)
        iconImageView.image             =   UIImage(named: menuItem.object(forKey: "icon") as! String)
        
        titleLabel.textColor            =   (menuItem.object(forKey: "isColor") as! Bool) ? UIColor.veryLightOrange : UIColor.veryLightGray
        
        if ((menuItem.object(forKey: "name") as! String).hasPrefix("OmnieCards")) {
            titleLabel.textColor        =   UIColor.lightGrayishCyan
        }
        
        if (menuItem.object(forKey: "hasNewEvent") as! Bool) {
            newEventButton.isHidden     =   false
            
            setupEvent(forMenuItem: menuItem)
        } else {
            newEventButton.isHidden     =   true
        }
        
        // Set selected color for Slide menu
        let selectedView                =   UIView.init(frame: self.frame)
        selectedView.backgroundColor    =   UIColor.veryDarkGrayishBlue38
        self.selectedBackgroundView     =   selectedView
    }
    
    func setupEvent(forMenuItem: NSDictionary) {
        if (forMenuItem.object(forKey: "segue") as! String).contains("News") {
            // API Get News
            newEventButton.setAttributedTitle(NSAttributedString(string: "23", attributes: UIFont.ubuntuLightVeryDarkGray12), for: .normal)
            self.tag                    =   4
        } else {
            // API Get Orders
            newEventButton.setAttributedTitle(NSAttributedString(string: "!", attributes: UIFont.ubuntuLightVeryDarkGray12), for: .normal)
            self.tag                    =   0
        }
    }
    
    
    // MARK: - Actions
    @IBAction func handlerNewEventButtonTap(_ sender: CustomButton) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        self.newEventButtonHandlerCompletion!(self)
    }
}
