//
//  TimeSheetTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 04.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class TimeSheetTableViewCell: UITableViewCell {
    // MARK: - Properties
    var time: Int?
    var isFree = true
    
    // Outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dottedLineView: UIView!
    
    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // MARK: - Custom Functions
//    func setup(forRow indexPath: IndexPath, withOrganization organization: Organization, andService service: Service) {
//        self.organization = organization
//        self.service = service
//        
//        timeLabel.text = "\(String(organization.workStartTime + indexPath.row).twoNumberFormat()):00"
//        time = organization.workStartTime + indexPath.row
//    }
}


// MARK: - ConfigureCell
extension TimeSheetTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let timeSheetItem = item as! TimeSheetItem
        
//        timeLabel.text = "\(String(timeSheetItem.start + indexPath.row).twoNumberFormat()):00"
//        time = organization.workStartTime + indexPath.row
        selectionStyle = .none
    }
}
