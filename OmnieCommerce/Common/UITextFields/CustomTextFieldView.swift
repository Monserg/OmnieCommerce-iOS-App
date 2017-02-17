//
//  CustomTextFieldView.swift
//  OmnieCommerce
//
//  Created by msm72 on 16.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

//protocol NameTextField {
//    func didApplySettings()
//}

class CustomTextFieldView: UIView {
    // MARK: - Properties
    @IBOutlet var view: UIView!
    @IBOutlet weak var textField: CustomTextField!
    @IBOutlet weak var passwordStrengthLevelView: PasswordStrengthLevelView!
    @IBOutlet weak var errorMessageView: ErrorMessageView!
    @IBOutlet weak var errorMessageLabel: CustomLabel!
    

    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createFromXIB()
    }

    
    // MARK: - Custom Functions
    func createFromXIB() {
        UINib(nibName: String(describing: CustomTextFieldView.self), bundle: Bundle(for: CustomTextFieldView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
        
        print(object: "\(type(of: self)): \(#function) run. Initialization view.frame = \(view.frame)")
    }
    


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


//// MARK: - NameTextField
//extension CustomTextField: NameTextField {
//    func didApplySettings() {
//        self.text
//    }
//}
