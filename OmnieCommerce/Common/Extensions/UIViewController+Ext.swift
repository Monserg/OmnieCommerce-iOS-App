//
//  UIViewController+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 06.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

extension UIViewController {
    func alertViewDidShow(withTitle title: String, andMessage message: String) {
        let alertViewController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let alertViewControllerAction = UIAlertAction.init(title: "Ok".localized(), style: .default, handler: nil)
        
        alertViewController.addAction(alertViewControllerAction)
        present(alertViewController, animated: true, completion: nil)
    }
}
