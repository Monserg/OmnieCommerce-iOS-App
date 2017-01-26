//
//  OmnieCardViewModel.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import UIKit

class OmnieCardViewModel {
    // MARK: - Class Functions
    func getBarCodeID() -> String {
        return OmnieCard.init().barcodeID
    }
    
    func createBarCode() -> UIImage?{
        return OmnieCard.init().generateBarcode(from: getBarCodeID())
    }
}
