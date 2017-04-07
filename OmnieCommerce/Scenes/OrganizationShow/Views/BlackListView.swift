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
        let newFrame = CGRect.init(origin: .zero, size: view.frame.size)
        super.init(frame: newFrame)
        
        createFromXIB()
        
        self.alpha = 0
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        view.addSubview(self)
        self.didShow()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
