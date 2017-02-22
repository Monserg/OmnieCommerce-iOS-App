//
//  AnimatedButton.swift
//  OmnieCommerce
//
//  Created by msm72 on 22.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class AnimatedButton: UIView {
    // MARK: - Properties
    @IBOutlet var view: UIView!
    @IBOutlet weak var addButton: CustomButton!
    @IBOutlet weak var businessCardButton: CustomButton!

    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createFromXIB()
    }
    
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
    }

    
    // MARK: - Custom Functions
    func createFromXIB() {
        UINib(nibName: String(describing: AnimatedButton.self), bundle: Bundle(for: AnimatedButton.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
    }
}
