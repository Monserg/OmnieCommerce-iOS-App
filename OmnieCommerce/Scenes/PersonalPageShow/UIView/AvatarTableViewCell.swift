//
//  AvatarTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import Alamofire

class AvatarTableViewCell: UITableViewCell {
    // MARK: - Properties
    var handlerSendButtonCompletion: HandlerSendButtonCompletion?
    
    @IBOutlet weak var actionButton: CustomButton!
 
    
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
    @IBAction func handlerActionButtonTap(_ sender: CustomButton) {
        handlerSendButtonCompletion!()
    }
}


// MARK: - ConfigureCell
extension AvatarTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        if let userApp = item as? AppUser {
            if (userApp.imagePath != nil) {
                Alamofire.request(userApp.imagePath!).responseImage { response in
                    if let image = response.result.value {
                        self.actionButton.setImage(image, for: .normal)
                        self.actionButton.imageView!.contentMode     =   .scaleAspectFit
                    }
                }
            }
        }
    }
}
