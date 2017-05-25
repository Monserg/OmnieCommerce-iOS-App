//
//  Barcode.swift
//  OmnieCommerce
//
//  Created by msm72 on 25.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreImage

class Barcode {
    // MARK: - Class Functions
    class func convertToImageFromString(_ string : String?) -> UIImage? {
        if let code = string {
            let data = code.data(using: .ascii)
            let filter = CIFilter(name: "CICode128BarcodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            
            return UIImage(ciImage: (filter?.outputImage)!)
        }
        
        return nil
    }
}
