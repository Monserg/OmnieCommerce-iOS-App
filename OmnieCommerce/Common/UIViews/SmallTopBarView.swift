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
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var dottesStackView: UIStackView!
    
    @IBInspectable var type: String = "Parent" {
        didSet {
            searchButton.isHidden = true
            dottesStackView.isHidden = false
            titleLabel.text = titleLabel.text?.localized()
            titleLabel.clipsToBounds = true
            actionButton.setBackgroundImage(UIImage.init(named: "icon-menu-normal"), for: .normal)

            switch ViewType(rawValue: type)! {
            case .Child:
                actionButton.setBackgroundImage(UIImage.init(named: "icon-back-normal"), for: .normal)

            case .ChildSearch:
                searchButton.isHidden = false

            case .Parent:
                actionButton.setBackgroundImage(UIImage.init(named: "icon-menu-normal"), for: .normal)

            case .ParentSearch:
                searchButton.isHidden = false
            }
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

    
    // MARK: - Actions
    
    @IBAction func handlerSearchButtonTap(_ sender: UIButton) {
        print(object: "\(type(of: self)): \(#function) run.")
        
    }
    
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        print(object: "\(type(of: self)): \(#function) run. Rect = \(rect)")
    }
}
