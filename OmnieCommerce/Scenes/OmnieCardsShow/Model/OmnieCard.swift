//
//  OmnieCard.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

//import Foundation
import UIKit

struct OmnieCard {
    // MARK: - Properties
    let barcodeID = "4606453749072"
    
    
    // MARK: - Custom Functions
    func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.applying(transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
}
