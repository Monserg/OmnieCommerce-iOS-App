//
//  AvatarTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class AvatarTableViewCell: UITableViewCell {
    // MARK: - Properties
//    weak var viewModel: CityCellViewModel! {
//        didSet {
//            self.actionButton..text = viewModel.timeString
//            self.cityLabel.text = viewModel.cityTitle
//            self.temperatureLabel.text = viewModel.temperatureString
//        }
//    }
    
    @IBOutlet weak var actionButton: CustomButton!
 
    
    // MARK: - Actions
    @IBAction func handlerActionButtonTap(_ sender: CustomButton) {
        print(object: #function)
    }
}
