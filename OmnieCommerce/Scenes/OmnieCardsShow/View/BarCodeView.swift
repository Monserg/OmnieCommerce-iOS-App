//
//  BarCodeView.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class BarCodeView: UIView {
    // MARK: - Properties
    @IBOutlet var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: CustomLabel!
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }

    
    // MARK: - Custom Functions
    func setup() {
        UINib(nibName: String(describing: BarCodeView.self), bundle: Bundle(for: BarCodeView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view!.frame = CGRect.init(origin: CGPoint.zero, size: frame.size)
        
        print(object: "\(type(of: self)): \(#function) run. Initialization view.frame = \(view.frame)")
    }
}
