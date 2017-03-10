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
    typealias CompletionVoid    =   ((_ sender: UIButton) -> ())
    
    var actionButtonHandlerCompletion: CompletionVoid?
    
    var leftTitle: String?
    var rightTitle: String?
    weak var selectedButton: UIButton?
    
    @IBInspectable var segmentedControlViewStyle: String = "" {
        didSet {
            let viewStyle       =   Config.ViewStyle(rawValue: segmentedControlViewStyle)!
            selectedButton      =   leftActionButton
            
            switch viewStyle {
            case .News:
                leftTitle       =   "Subscription".localized()
                rightTitle      =   "Hot News".localized()

            case .Calendar:
                leftTitle       =   "Calendar".localized()
                rightTitle      =   "Schedule".localized()

            case .PersonalPage:
                leftTitle       =   "Personal Data".localized()
                rightTitle      =   "My Templates".localized()
            
            case .Favourite:
                leftTitle       =   "Organizations".localized()
                rightTitle      =   "Services".localized()
            }
            
            leftActionButton.setAttributedTitle(NSAttributedString(string: leftTitle!, attributes: UIFont.ubuntuLightVeryLightOrange16), for: .normal)
            rightActionButton.setAttributedTitle(NSAttributedString(string: rightTitle!, attributes: UIFont.ubuntuLightVeryLightGray16), for: .normal)
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
        
        if (selectedButton!.tag == 1) {
            self.selectedView.frame     =   CGRect.init(origin: CGPoint.init(x: selectedButton!.frame.minX + 8, y: selectedButton!.frame.maxY),
                                                        size: self.selectedView.bounds.size)
        }
        
        // Set vertical style
        if (self.tag == 99) {
            self.leftActionButton.setVerticalTitleStyle()
            self.rightActionButton.setVerticalTitleStyle()
        }
    }

    deinit {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]")
    }


    // MARK: - Custom Functions
    func setupView() {
        if (self.tag == 1) {
            UINib(nibName: "SegmentedControlViewLandscape", bundle: Bundle(for: SegmentedControlView.self)).instantiate(withOwner: self, options: nil)
        } else {
            UINib(nibName: String(describing: SegmentedControlView.self), bundle: Bundle(for: SegmentedControlView.self)).instantiate(withOwner: self, options: nil)
        }
        
        addSubview(view)
        view.frame              =   frame
        view.backgroundColor    =   UIColor.veryDarkDesaturatedBlue24
        
        print(object: "\(type(of: self)): \(#function) run. Initialization view.frame = \(view.frame)")
    }

    
    // MARK: - Actions
    @IBAction func handlerActionButtonTap(_ sender: UIButton) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        if (self.selectedButton!.tag != sender.tag) {
            switch sender.tag {
            case 0:
                leftActionButton.setAttributedTitleWithoutAnimation(title: NSAttributedString(string: leftTitle!,
                                                                                              attributes: UIFont.ubuntuLightVeryLightOrange16))
                
                rightActionButton.setAttributedTitleWithoutAnimation(title: NSAttributedString(string: rightTitle!,
                                                                                               attributes: UIFont.ubuntuLightVeryLightGray16))
                
            case 1:
                leftActionButton.setAttributedTitleWithoutAnimation(title: NSAttributedString(string: leftTitle!,
                                                                                              attributes: UIFont.ubuntuLightVeryLightGray16))
                
                rightActionButton.setAttributedTitleWithoutAnimation(title: NSAttributedString(string: rightTitle!,
                                                                                               attributes: UIFont.ubuntuLightVeryLightOrange16))
                
            default:
                break
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                if (self.tag == 0) {
                    self.selectedView.frame = CGRect.init(origin: CGPoint.init(x: sender.frame.minX + 8, y: sender.frame.maxY),
                                                          size: self.selectedView.bounds.size)
                } else {
                    if (UIApplication.shared.statusBarOrientation.isPortrait) {
                        self.selectedView.frame = CGRect.init(origin: CGPoint.init(x: sender.frame.minX + 8, y: sender.frame.maxY),
                                                              size: self.selectedView.bounds.size)
                    } else {
                        self.selectedView.frame = CGRect.init(origin: CGPoint.init(x: sender.frame.maxX, y: sender.frame.minY + 8),
                                                              size: self.selectedView.bounds.size)
                    }
                }
            }, completion: { success in
                if (success) {
                    self.selectedButton = sender
                    
                    self.actionButtonHandlerCompletion!(sender)
                }
            })
        }
    }
}
