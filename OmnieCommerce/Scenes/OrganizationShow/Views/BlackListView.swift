//
//  BlackListView.swift
//  OmnieCommerce
//
//  Created by msm72 on 05.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation

class BlackListView: CustomView {
    // MARK: - Properties
    var isShow: Bool = false
    
    var handlerCancelButtonCompletion: HandlerCancelButtonCompletion?
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.font = UIFont.ubuntuLight12
            textView.textColor = UIColor.veryLightGray
            textView.text = textView.text.localized()
        }
    }
    
    
    // MARK: - Class Initialization
    init(inView view: UIView) {
        super.init(frame: view.frame)
        
        createFromXIB()
        
        self.alpha = 0
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        view.addSubview(self)

        let widthRatio = ((UIApplication.shared.statusBarOrientation.isPortrait) ? 375 : 667) / view.frame.width
        let heightRatio = ((UIApplication.shared.statusBarOrientation.isPortrait) ? 667 : 375) / view.frame.height
        self.frame = CGRect.init(x: 0, y: 0, width: 345 * widthRatio, height: 185 * heightRatio)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        self.didShow()
    }
    
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
    
    override func didHide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }, completion: { success in
            self.removeFromSuperview()
            
            self.handlerCancelButtonCompletion!()
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.indicatorDidChange(UIColor.veryLightOrange)
    }
    
    
    // MARK: - Custom Functions
    func createFromXIB() {
        UINib(nibName: String(describing: BlackListView.self), bundle: Bundle(for: BlackListView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
    }
    
    
    // MARK: - Actions
    @IBAction func handlerCancelButtonTap(_ sender: UIButton) {
        self.didHide()
    }
}
