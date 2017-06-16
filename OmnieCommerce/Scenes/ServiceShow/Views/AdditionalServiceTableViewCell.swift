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
    @IBOutlet weak var totalPriceLabel: UbuntuLightItalicLightGrayishCyanLabel!
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

        pickerView.isHidden = !sender.isOn
        separatorsView.isHidden = !sender.isOn
        pickerView.isUserInteractionEnabled = sender.isOn
        
        handlerSwitchChangeStateCompletion!(sender.isOn)
    }
}


// MARK: - ConfigureCell
extension AdditionalServiceTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let additionalService = item as! AdditionalService
        
        nameLabel.text = additionalService.name
        nameLabel.isEnabled = stateSwitch.isOn
        priceLabel.isEnabled = stateSwitch.isOn
        
        self.pricesDidUpload(forAdditionalService: additionalService)
        
        // Quantity UIPickerView
        pickerView.isHidden = true
        separatorsView.isHidden = true
        pickerView.isUserInteractionEnabled = false

        switch (additionalService.minValue + additionalService.maxValue) {
        case 0:
            pickerData = Array(Int(1)...Int(2000))
            pickerView.selectRow(0, inComponent: 0, animated: true)
            
        case 2:
            pickerView.isHidden = true
            separatorsView.isHidden = true

        default:
            pickerData = Array(Int(additionalService.minValue)...Int(additionalService.maxValue))
            pickerView.selectRow(0, inComponent: 0, animated: true)
        }
        
        // Handler change quantity
        handlerPickerChangeValueCompletion = { row in
            self.pricesDidUpload(forAdditionalService: additionalService)
        }
    }
    
    func pricesDidUpload(forAdditionalService additionalService: AdditionalService) {
        if (pickerView.selectedRow(inComponent: 0) == 0) {
            priceLabel.text = String(format: "%3.2f %@", additionalService.price, additionalService.unitName)
            totalPriceLabel.text = nil
        } else {
            priceLabel.text = String(format: "%3.2f %@", additionalService.price, additionalService.unitName)
            totalPriceLabel.text = String(format: "%3.2f грн.", additionalService.price  * Double(pickerView.selectedRow(inComponent: 0) + 1))
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
