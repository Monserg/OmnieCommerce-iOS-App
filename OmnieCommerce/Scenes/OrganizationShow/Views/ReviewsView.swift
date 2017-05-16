//
//  ReviewsView.swift
//  OmnieCommerce
//
//  Created by msm72 on 04.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import Cosmos

class ReviewsView: CustomView {
    // MARK: - Properties
    var isShow: Bool = false
    
    var handlerSendButtonCompletion: HandlerPassDataCompletion?
    
    // Outlets
    @IBOutlet var view: UIView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer))
            view.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet weak var commentTextView: UITextView! {
        didSet {
            commentTextView.delegate = self
            commentTextView.text = commentTextView.text.localized()
            textViewPlaceholderDidUpload(commentTextView.text)
        }
    }
    
    @IBOutlet weak var ratingView: CosmosView! {
        didSet {
            ratingView.settings.starMargin = Double(CGFloat(ratingView.frame.width - 23.0 * 5) / CGFloat(4.0))
            ratingView.settings.fillMode = .full
        }
    }

    @IBOutlet weak var themeTextField: CustomTextField! {
        didSet {
            themeTextField.delegate = self
        }
    }

    
    @IBOutlet weak var themeDottedView: DottedBorderView! {
        didSet {
            themeDottedView.style = .BottomDottedLine
        }
    }
    
    @IBOutlet weak var commentDottedView: DottedBorderView! {
        didSet {
            commentDottedView.style = .AroundDottedRectangle
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
        UINib(nibName: String(describing: ReviewsView.self), bundle: Bundle(for: ReviewsView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
    }
    
    func textViewPlaceholderDidUpload(_ text: String?) {
        if (text == nil) {
            commentTextView.text = ""
            commentTextView.font = UIFont.ubuntuLight12
            commentTextView.textColor = UIColor.veryLightGray
        } else if (text == "Comment".localized() || text!.isEmpty) {
            commentTextView.text = "Comment".localized()
            commentTextView.font = UIFont.ubuntuLightItalic12
            commentTextView.textColor = UIColor.darkCyan
        } else {
            commentTextView.font = UIFont.ubuntuLight12
            commentTextView.textColor = UIColor.veryLightGray
        }
    }
    
    
    // MARK: - Actions
    @IBAction func handlerSendButtonTap(_ sender: FillVeryLightOrangeButton) {
        guard isNetworkAvailable else {
            handlerSendButtonCompletion!(nil)
            self.didHide()
            
            return
        }
        
        // TODO: TEST API "SEND REVIEW"
        handlerSendButtonCompletion!([ "organizationId": values?.first as! String, "text": commentTextView.text, "mark": Int(ratingView.rating) ])
        self.didHide()
    }
    
    @IBAction func handlerCancelButtonTap(_ sender: UIButton) {
        self.didHide()
    }
    
    func handleTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}


// MARK: - UITextFieldDelegate
extension ReviewsView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - UITextViewDelegate
extension ReviewsView: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textViewPlaceholderDidUpload((textView.text == "Comment".localized()) ? nil : textView.text)
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textViewPlaceholderDidUpload(textView.text)
        return true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}
