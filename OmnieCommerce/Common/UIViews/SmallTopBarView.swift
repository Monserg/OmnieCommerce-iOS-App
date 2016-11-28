//
//  SmallTopBarView.swift
//  OmnieCommerce
//
//  Created by msm72 on 28.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

enum ViewType: String {
    case Child = "Child"
    case Parent = "Parent"
    case ChildSearch = "ChildSearch"
    case ParentSearch = "ParentSearch"
}

@IBDesignable class SmallTopBarView: UIView {
    // MARK: - Properties
    @IBOutlet var view: UIView!
    @IBOutlet weak var circleView: SmallCirleView!
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var dottesStackView: UIStackView!
    
    @IBInspectable var titleText: String? {
        didSet {
            setup()
        }
    }
    
    @IBInspectable var type: String? {
        didSet {
            setup()
        }
    }
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        UINib(nibName: String(describing: SmallTopBarView.self), bundle: Bundle(for: SmallTopBarView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
        
        print(object: "\(type(of: self)): \(#function) run. Initialization view.frame = \(view.frame)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        UINib(nibName: String(describing: SmallTopBarView.self), bundle: Bundle(for: SmallTopBarView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
        
        print(object: "\(type(of: self)): \(#function) run. Initialization view.frame = \(view.frame)")
    }
    
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        print(object: "\(type(of: self)): \(#function) run. Rect = \(rect)")
    }
    
    
    // MARK: - Actions
    @IBAction func handlerSearchButtonTap(_ sender: UIButton) {
        print(object: "\(type(of: self)): \(#function) run.")
        
    }

    
    // MARK: - Custom Functions
    func setup() {
        searchButton.isHidden = true
        actionButton.isHidden = false
        titleLabel.clipsToBounds = true
        dottesStackView.isHidden = false
        titleLabel.text = titleText?.localized() ?? "Label"
        actionButton.setImage(UIImage.init(named: "icon-menu-normal"), for: .normal)
        
        switch ViewType(rawValue: type ?? "Parent")! {
        case .Child:
            actionButton.setImage(UIImage.init(named: "icon-back-normal"), for: .normal)
            
        case .ChildSearch:
            searchButton.isHidden = false
            
        case .ParentSearch:
            searchButton.isHidden = false
            
        case .Parent:
            actionButton.setImage(UIImage.init(named: "icon-menu-normal"), for: .normal)
        }
    }
}
