//
//  ActionButtonsTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 04.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class ActionButtonsTableViewCell: UITableViewCell {
    // MARK: - Properties
    var handlerSendButtonCompletion: HandlerSendButtonCompletion?
    var handlerCancelButtonCompletion: HandlerCancelButtonCompletion?
        
    
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

    
    // MARK: - Custom Functions
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {}

    
    // MARK: - Actions
    @IBAction func handlerSaveButtonTap(_ sender: FillVeryLightOrangeButton) {
        handlerSendButtonCompletion!()
    }
    
    @IBAction func handlerCancelButtonTap(_ sender: CustomButton) {
        handlerCancelButtonCompletion!()
    }
}


// MARK: - ConfigureCell
extension ActionButtonsTableViewCell: ConfigureCell {
    
}
