//
//  MSMTableViewFooterView.swift
//  OmnieCommerce
//
//  Created by msm72 on 26.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class MSMTableViewFooterView: UITableViewHeaderFooterView {
    // MARK: - Properties
//    @IBOutlet var view: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var infiniteScrollView: UIView! {
        didSet {
//            (infiniteScrollView.isHidden) ? spinner.stopAnimating() : spinner.startAnimating()
        }
    }
    
    
    // MARK: - Class Initialization
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        createFromXIB()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        createFromXIB()
//    }
//    
//    
//    // MARK: - Class Functions
//    func createFromXIB() {
//        UINib(nibName: String(describing: MSMTableViewFooterView.self), bundle: Bundle(for: MSMTableViewFooterView.self)).instantiate(withOwner: self, options: nil)
//        addSubview(view)
//        view.frame = frame
//    }
}
