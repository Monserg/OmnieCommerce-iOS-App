//
//  BigTopBarView.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class BigTopBarView: UIView {
    // MARK: - Properties
    @IBOutlet var view: UIView!
    @IBOutlet weak var circleView: BigCirleView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    
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
    func createFromXIB() {
        UINib(nibName: String(describing: BigTopBarView.self), bundle: Bundle(for: BigTopBarView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
        
        print(object: "\(type(of: self)): \(#function) run. Initialization view.frame = \(view.frame)")
    }

    override func draw(_ rect: CGRect) {
        print(object: "\(type(of: self)): \(#function) run. Rect = \(rect)")
        
        logoImageView.image = UIImage(named: (rect.size.width < rect.size.height) ? "image-logo-horizontal" : "image-logo-vertical")
    }
}
