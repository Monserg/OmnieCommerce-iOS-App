//
//  AdditionalServiceTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class AdditionalServiceTableViewCell: UITableViewCell {
    // MARK: - Properties
    var handlerSwitchChangeStateCompletion: HandlerPassDataCompletion?
    var handlerPickerChangeValueCompletion: HandlerPassDataCompletion?

    var pickerData: [Int]! {
        didSet {
            pickerView.delegate = self
            pickerView.dataSource = self
        }
    }

    
    // MARK: - Outlets
    @IBOutlet var labelsCollection: [UILabel]!
    @IBOutlet weak var nameLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var priceLabel: UbuntuLightVeryLightOrangeLabel!
    @IBOutlet weak var durationLabel: UbuntuLightItalicLightGrayishCyanLabel!
    @IBOutlet weak var separatorsView: UIView!
    
    @IBOutlet weak var stateSwitch: UISwitch! {
        didSet {
            stateSwitch.onTintColor = UIColor.darkCyan
            stateSwitch.tintColor = UIColor.init(hexString: "#959ba0")
            stateSwitch.layer.cornerRadius = 16.0
        }
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - Actions
    @IBAction func handlerChangeSwitchState(_ sender: UISwitch) {
        let _ = labelsCollection.map { $0.isEnabled = sender.isOn }
        pickerView.isUserInteractionEnabled = sender.isOn
//        stateSwitch.thumbTintColor = (stateSwitch.isOn) ? UIColor.veryLightOrange : UIColor.init(hexString: "#acaeb0")
        
        handlerSwitchChangeStateCompletion!(sender.isOn)
    }
}


// MARK: - ConfigureCell
extension AdditionalServiceTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let additionalService = item as! AdditionalService
        let durationMinutes = Int(additionalService.duration / 60.0 / 1_000.0)
        
        nameLabel.text = additionalService.name

        if (durationMinutes == 0) {
            durationLabel.text = nil
            priceLabel.text = String(format: "%3.2f %@", additionalService.price, additionalService.unitName)
        } else {
            durationLabel.text = "\(durationMinutes) \("Minutes short".localized())"
            
            if (additionalService.unit == 0) {
                priceLabel.text = String(format: "%3.2f %@", additionalService.price / 60.0 * Double(durationMinutes), additionalService.unitName.components(separatedBy: "/").first!)
            } else {
                priceLabel.text = String(format: "%3.2f %@", additionalService.price, additionalService.unitName)
            }
        }
        
        if (additionalService.minValue + additionalService.maxValue == 0) {
            pickerView.isHidden = true
            separatorsView.isHidden = true
        } else {
            pickerData = Array(Int(additionalService.minValue)...Int(additionalService.maxValue + 20))
            pickerView.selectRow(1, inComponent: 0, animated: true)
        }
        
        // Handler change quantity
        handlerPickerChangeValueCompletion = { row in
            if (additionalService.unit == 0) {
                self.priceLabel.text = String(format: "%3.2f %@", additionalService.price / 60.0 * Double(durationMinutes * (row as! Int)), additionalService.unitName.components(separatedBy: "/").first!)
            } else {
                self.priceLabel.text = String(format: "%3.2f %@", additionalService.price * Double(row as! Int), additionalService.unitName)
            }

            self.durationLabel.text = "\(durationMinutes * (row as! Int)) \("Minutes short".localized())"
        }
    }
}


// MARK: - UIPickerViewDataSource
extension AdditionalServiceTableViewCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
}


// MARK: - UIPickerViewDelegate
extension AdditionalServiceTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 37.0 * self.heightRatio
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as! UILabel!
        
        if label == nil {
            label = UILabel()
        }
        
        label!.attributedText = NSAttributedString(string: String(pickerData[row]), attributes: UIFont.ubuntuLightVeryLightGray12)
        label!.textAlignment = .center
        
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        handlerPickerChangeValueCompletion!(row)
    }
}
