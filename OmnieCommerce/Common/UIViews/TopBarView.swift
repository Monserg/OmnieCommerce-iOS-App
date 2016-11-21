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

        UINib(nibName: NSStringFromClass(self.classForCoder), bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        UINib(nibName: NSStringFromClass(self.classForCoder), bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
    }
}
