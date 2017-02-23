//
//  SmallTopBarView.swift
//  OmnieCommerce
//
//  Created by msm72 on 28.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

enum ViewType: String {
    case Child          =   "Child"
    case Parent         =   "Parent"
    case ChildSearch    =   "ChildSearch"
    case ParentSearch   =   "ParentSearch"
}

@IBDesignable class SmallTopBarView: UIView {
    // MARK: - Properties
    var handlerSendButtonCompletion: HandlerSendButtonCompletion?
    
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
        
        createFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        createFromXIB()
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
    func createFromXIB() {
        UINib(nibName: String(describing: SmallTopBarView.self), bundle: Bundle(for: SmallTopBarView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
        
        setup()
    }
    
    private func setup() {
        searchButton.isHidden       =   true
        actionButton.isHidden       =   false
        titleLabel.clipsToBounds    =   true
        dottesStackView.isHidden    =   false
        titleLabel.text             =   titleText?.localized() ?? "Label"
        actionButton.setImage(UIImage.init(named: "icon-menu-normal"), for: .normal)
        
        switch ViewType(rawValue: type ?? "Parent")! {
        case .Child:
            actionButton.setImage(UIImage.init(named: "icon-previous-item-normal"), for: .normal)
            
        case .ChildSearch:
            searchButton.isHidden   =   false

            actionButton.setImage(UIImage.init(named: "icon-previous-item-normal"), for: .normal)
            actionButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            actionButton.addTarget(self, action: #selector(handlerLeftActionButtonTap), for: .touchUpInside)
            
        case .ParentSearch:
            searchButton.isHidden   =   false
            
        case .Parent:
            actionButton.setImage(UIImage.init(named: "icon-menu-normal"), for: .normal)
        }
    }
    
    
    // MARK: - Actions
    func handlerLeftActionButtonTap(_ sender: UIButton) {
        handlerSendButtonCompletion!()
    }
}
