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
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    @IBOutlet weak var infiniteScrollView: UIView! {
        didSet {
            (infiniteScrollView.isHidden) ? spinner.stopAnimating() : spinner.startAnimating()
        }
    }
}
