//
//  SegmentedControlView.swift
//  OmnieCommerce
//
//  Created by msm72 on 05.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import Localize_Swift

@IBDesignable class SegmentedControlView: UIView {
    // MARK: - Properties
    typealias CompletionVoid = ((_ sender: UIButton) -> ())
    
    var actionButtonHandlerCompletion: CompletionVoid?
    var leftTitle = String()
    var rightTitle = String()
    var selectedButton = UIButton()
    
    @IBInspectable var segmentedControlViewStyle: String = "" {
        didSet {
            let viewStyle = Config.ViewStyle(rawValue: segmentedControlViewStyle)!
            selectedButton = leftActionButton
            
            switch viewStyle {
            case .News:
                leftTitle = "Subscription".localized()
                rightTitle = "Hot News".localized()

            case .Calendar:
                leftTitle = "Calendar".localized()
                rightTitle = "Schedule".localized()

            case .PersonalPage:
                leftTitle = "Personal Data".localized()
                rightTitle = "My Templates".localized()
            
            case .Favourite:
                leftTitle = "Organizations".localized()
                rightTitle = "Services".localized()
            }
            
            leftActionButton.setAttributedTitle(NSAttributedString(string: leftTitle, attributes: UIFont.ubuntuLightVeryLightOrange16), for: .normal)
            rightActionButton.setAttributedTitle(NSAttributedString(string: rightTitle, attributes: UIFont.ubuntuLightVeryLightGray16), for: .normal)
        }
    }

    @IBOutlet var view: UIView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var leftActionButton: UIButton!
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
        
        if (selectedButton.tag == 1) {
            self.selectedView.frame = CGRect.init(origin: CGPoint.init(x: selectedButton.frame.minX + 8, y: selectedButton.frame.maxY), size: self.selectedView.bounds.size)
        }
    }


    // MARK: - Custom Functions
    func setupView() {
        UINib(nibName: String(describing: SegmentedControlView.self), bundle: Bundle(for: SegmentedControlView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
        view.backgroundColor = UIColor.veryDarkDesaturatedBlue24
        
        print(object: "\(type(of: self)): \(#function) run. Initialization view.frame = \(view.frame)")
    }

    
    // MARK: - Actions
    @IBAction func handlerActionButtonTap(_ sender: UIButton) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        switch sender.tag {
        case 0:
            leftActionButton.setAttributedTitle(NSAttributedString(string: leftTitle, attributes: UIFont.ubuntuLightVeryLightOrange16), for: .normal)
            rightActionButton.setAttributedTitle(NSAttributedString(string: rightTitle, attributes: UIFont.ubuntuLightVeryLightGray16), for: .normal)
            
        case 1:
            leftActionButton.setAttributedTitle(NSAttributedString(string: leftTitle, attributes: UIFont.ubuntuLightVeryLightGray16), for: .normal)
            rightActionButton.setAttributedTitle(NSAttributedString(string: rightTitle, attributes: UIFont.ubuntuLightVeryLightOrange16), for: .normal)
            
        default:
            break
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.selectedView.frame = CGRect.init(origin: CGPoint.init(x: sender.frame.minX + 8, y: sender.frame.maxY), size: self.selectedView.bounds.size)
        }, completion: { success in
            if (success) {
                self.selectedButton = sender

                self.actionButtonHandlerCompletion!(sender)
            }
        })
    }
}
