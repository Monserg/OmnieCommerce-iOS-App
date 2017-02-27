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
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate      =   self
        }
    }
    
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
    
    
    // MARK: - Custom Functions
    func createFromXIB() {
        UINib(nibName: String(describing: SmallTopBarView.self), bundle: Bundle(for: SmallTopBarView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
        
        setup()
    }
    
    private func setup() {
        searchButton.alpha                  =   0
        actionButton.alpha                  =   1
        titleLabel.clipsToBounds            =   true
        dottesStackView.alpha               =   1
        titleLabel.text                     =   titleText?.localized() ?? "Label"
        actionButton.setImage(UIImage.init(named: "icon-menu-normal"), for: .normal)
        searchBar.barTintColor              =   UIColor.darkCyan
        searchBar.tintColor                 =   UIColor.veryLightGray
        searchBar.layer.borderWidth         =   1
        searchBar.layer.borderColor         =   UIColor.darkCyan.cgColor
        
        searchBarDidSetup()
        
        switch ViewType(rawValue: type ?? "Parent")! {
        case .Child:
            actionButton.setImage(UIImage.init(named: "icon-back-bar-button-normal"), for: .normal)
            
        case .ChildSearch:
            searchButton.alpha              =   1

            actionButton.setImage(UIImage.init(named: "icon-back-bar-button-normal"), for: .normal)
            actionButton.imageEdgeInsets    =   UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            actionButton.addTarget(self, action: #selector(handlerLeftActionButtonTap), for: .touchUpInside)
            
        case .ParentSearch:
            searchButton.alpha              =   1
            
        case .Parent:
            actionButton.setImage(UIImage.init(named: "icon-menu-normal"), for: .normal)
        }
    }
    
    private func searchBarDidSetup() {
        for subview in self.searchBar.subviews {
            for innerSubViews in subview.subviews {
                if let cancelButton = innerSubViews as? UIButton {
                    cancelButton.setAttributedTitle(NSAttributedString.init(string: cancelButton.titleLabel!.text!,
                                                                            attributes: UIFont.ubuntuLightVeryLightGray16),
                                                    for: .normal)
                }
                
                if let textField = innerSubViews as? UITextField {
                    textField.backgroundColor           =   UIColor.darkCyan
                    textField.textColor                 =   UIColor.veryLightGray
                    textField.tintColor                 =   UIColor.veryLightGray
                    
                    textField.attributedPlaceholder     =   NSAttributedString.init(string: "Enter search text".localized(),
                                                                                    attributes: UIFont.ubuntuLightItalicVeryLightGray16)
                    
                    if let iconView = textField.leftView as? UIImageView {
                        iconView.image                  =   iconView.image?.withRenderingMode(.alwaysTemplate)
                        iconView.tintColor              =   UIColor.veryLightGray
                    }
                    
                    textField.changeClearButtonColor()
                }
            }
        }
        
        searchBar.transform                             =   CGAffineTransform(translationX: 800, y: 0)
    }
    
    
    // MARK: - Actions
    func handlerLeftActionButtonTap(_ sender: UIButton) {
        handlerSendButtonCompletion!()
    }
    
    @IBAction func handlerSearchButtonTap(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.alpha                                =   0
            self.titleLabel.alpha                       =   0
        }, completion: { success in
            UIView.animate(withDuration: 0.3, animations: {
//                self.view.bringSubview(toFront: self.searchBar)
                self.searchBar.alpha                    =   1
                self.searchBar.transform                =   CGAffineTransform(translationX: 0, y: 0)

                self.searchBar.becomeFirstResponder()
            })
        })
    }
}


// MARK: - UISearchBarDelegate
extension SmallTopBarView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        // TODO: - ADD API TO SEARCH ORGANIZATIONS
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3, animations: {
//            self.view.bringSubview(toFront: self.searchBar)
            self.searchBar.alpha                        =   0
            self.searchBar.transform                    =   CGAffineTransform(translationX: 800, y: 0)
        }, completion: { success in
            UIView.animate(withDuration: 0.5, animations: {
                self.searchButton.alpha                 =   1
                self.titleLabel.alpha                   =   1
            })
            
            searchBar.resignFirstResponder()
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
}
