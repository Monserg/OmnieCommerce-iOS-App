//
//  SegmentedControlView.swift
//  OmnieCommerce
//
//  Created by msm72 on 05.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import Localize_Swift

enum SegmentedControlViewStyle: String {
    case News = "News"
}

@IBDesignable class SegmentedControlView: UIView {
    // MARK: - Properties
    typealias CompletionVoid = ((_ sender: UIButton) -> ())
    
    var actionButtonHandlerCompletion: CompletionVoid?
    
    @IBInspectable var segmentedControlViewStyle: String = "" {
        didSet {
            let style = SegmentedControlViewStyle(rawValue: segmentedControlViewStyle)!
            
            switch style {
            case .News:
                leftActionbutton.setAttributedTitle(NSAttributedString(string: "Subscription".localized(), attributes: UIFont.ubuntuLightVeryLightGray16), for: .highlighted)
                leftActionbutton.setAttributedTitle(NSAttributedString(string: "Subscription".localized(), attributes: UIFont.ubuntuLightVeryLightOrange16), for: .normal)

                rightActionButton.setAttributedTitle(NSAttributedString(string: "Hot News".localized(), attributes: UIFont.ubuntuLightVeryLightGray16), for: .normal)
                rightActionButton.setAttributedTitle(NSAttributedString(string: "Hot News".localized(), attributes: UIFont.ubuntuLightVeryLightOrange16), for: .highlighted)
            }
        }
    }
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var leftActionbutton: UIButton!
    @IBOutlet weak var rightActionButton: UIButton!
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }

    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        backgroundColor = UIColor.veryDarkDesaturatedBlue24
    }


    // MARK: - Custom Functions
    func setupView() {
        UINib(nibName: String(describing: SegmentedControlView.self), bundle: Bundle(for: SegmentedControlView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
        
        print(object: "\(type(of: self)): \(#function) run. Initialization view.frame = \(view.frame)")
    }

    
    // MARK: - Actions
    @IBAction func handlerActionButtonTap(_ sender: UIButton) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        switch sender.tag {
        case 0:
            leftActionbutton.setAttributedTitle(NSAttributedString(string: "Subscription".localized(), attributes: UIFont.ubuntuLightVeryLightGray16), for: .highlighted)
            leftActionbutton.setAttributedTitle(NSAttributedString(string: "Subscription".localized(), attributes: UIFont.ubuntuLightVeryLightOrange16), for: .normal)
            
            rightActionButton.setAttributedTitle(NSAttributedString(string: "Hot News".localized(), attributes: UIFont.ubuntuLightVeryLightGray16), for: .normal)
            rightActionButton.setAttributedTitle(NSAttributedString(string: "Hot News".localized(), attributes: UIFont.ubuntuLightVeryLightOrange16), for: .highlighted)
            
        case 1:
            leftActionbutton.setAttributedTitle(NSAttributedString(string: "Subscription".localized(), attributes: UIFont.ubuntuLightVeryLightGray16), for: .normal)
            leftActionbutton.setAttributedTitle(NSAttributedString(string: "Subscription".localized(), attributes: UIFont.ubuntuLightVeryLightOrange16), for: .highlighted)
            
            rightActionButton.setAttributedTitle(NSAttributedString(string: "Hot News".localized(), attributes: UIFont.ubuntuLightVeryLightGray16), for: .highlighted)
            rightActionButton.setAttributedTitle(NSAttributedString(string: "Hot News".localized(), attributes: UIFont.ubuntuLightVeryLightOrange16), for: .normal)
            
        default:
            break
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.selectedView.frame = CGRect.init(origin: CGPoint.init(x: sender.frame.minX + 8, y: sender.frame.maxY), size: self.selectedView.bounds.size)
        }, completion: { success in
            if (success) {
                self.actionButtonHandlerCompletion!(sender)
            }
        })
    }
}
