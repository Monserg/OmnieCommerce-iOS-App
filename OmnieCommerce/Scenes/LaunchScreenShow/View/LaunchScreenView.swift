//
//  LaunchScreenView.swift
//  OmnieCommerce
//
//  Created by msm72 on 11.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class LaunchScreenView: UIView {
    // MARK: - Properties
    @IBOutlet var view: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var blackoutView: UIView!
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }
    
    
    // MARK: - Custom Functions
    func setup() {
        let isUserGuest = Config.Constants.isUserGuest
        UINib(nibName: String(describing: LaunchScreenView.self), bundle: Bundle(for: LaunchScreenView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
        backgroundImageView.isHidden = (isUserGuest) ? false : true

        print(object: "\(type(of: self)): \(#function) run. Initialization view.frame = \(view.frame)")
    }
}
