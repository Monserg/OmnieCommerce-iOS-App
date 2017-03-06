//
//  GenderTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 06.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class GenderTableViewCell: UITableViewCell {
    // MARK: - Properties
//    var handlerSendButtonCompletion: HandlerSendButtonCompletion?
//    var handlerCancelButtonCompletion: HandlerCancelButtonCompletion?
    @IBOutlet var radioButtonsCollection: [DLRadioButton]!
    
    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    deinit {
        print(object: "\(type(of: self)) deinit")
    }
    
    
    // MARK: - Actions

}


// MARK: - ConfigureCell
extension GenderTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let userApp     =   item as! AppUser
        
        switch userApp.gender {
        case 0:
            radioButtonsCollection[0].isSelected    =   true
            
        case 1:
            radioButtonsCollection[1].isSelected    =   true

        default:
            break
        }
    }
}
