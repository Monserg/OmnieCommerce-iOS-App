//
//  BigTopBarView.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

//@IBDesignable
class BigTopBarView: UIView {
    // MARK: - Properties
    @IBOutlet var view: UIView!
    @IBOutlet weak var circleView: BigCirleView!
    
    
    // MARK: - Class initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        UINib(nibName: "BigTopBarView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        UINib(nibName: "BigTopBarView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
    }
}
