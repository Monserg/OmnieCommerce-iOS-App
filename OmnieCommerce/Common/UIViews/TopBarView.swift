//
//  TopBarView.swift
//  OmnieCommerce
//
//  Created by msm72 on 10.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class TopBarView: UIView {
    // MARK: - Properties
    @IBOutlet var view: UIView!
    @IBOutlet weak var circleView: CircleView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBInspectable var titleText: String? {
        didSet {
            // Enter "Hide" for don't show panel
            if titleText != "Hide" {
                titleLabel.text = titleText!.localized()
            } else {
                navigationBarView.isHidden = true
            }
        }
    }
 
    
    // MARK: - Class initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        UINib(nibName: "TopBarView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
    }

    
    // TODO: - MAY BE ADD CONFIG/SETUP FUNC?
    // Config
    //    titleLabel.font = Config.Labels.Fonts.helveticaNeueCyr32
    //    titleLabel.textColor = Config.Labels.Colors.veryLightGray
    //view.backgroundColor = Config.Views.Colors.darkCyan
    
    // FIXME: USE FOR KERN WORD
    // titleLabel.attributedText = NSAttributedString(string: "commerce", attributes: Config.Labels.Fonts.helveticaNeueCyrRoman16Kern486)

}
