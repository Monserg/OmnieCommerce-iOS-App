//
//  CustomImageView.swift
//  OmnieCommerce
//
//  Created by msm72 on 01.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

@IBDesignable class CustomImageView: UIImageView {
    // MARK: - Properties
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {

    }
    
    
    // MARK: - Custom Functions
//    func downloadImage(pathString: String?) {
//        let imageView = UIImageView(frame: frame)
//        let url = URL(string: pathString ?? "https://omniesoft.ua/")!
//        let placeholderImage = UIImage(named: "image-no-photo")!
//        
//        imageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
//        
//        Alamofire.request(url).responseImage { uploadedImage in
//            self.image = uploadedImage
//        }
//    }
}
