//
//  Barcode.swift
//  OmnieCommerce
//
//  Created by msm72 on 25.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import RSBarcodes_Swift
import AVFoundation

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
    
    class func generateBarcodeFrom(stringCode code: String, withImageSize imageSize: CGSize) -> UIImage? {
        let generator = RSUnifiedCodeGenerator.shared
        generator.fillColor = UIColor.white
        generator.strokeColor = UIColor.black

        if let type = codeDidValidate(code) {
            if (type == AVMetadataObjectTypeCode128Code) {
                for valueRaw in 0...3 {
                    if let image = RSCode128Generator(codeTable: RSCode128GeneratorCodeTable.init(rawValue: valueRaw)!).generateCode(code, machineReadableCodeObjectType: AVMetadataObjectTypeCode128Code) {
                        return RSAbstractCodeGenerator.resizeImage(image, targetSize: imageSize, contentMode: .scaleAspectFill)!
                    }
                }
            } else if let image = generator.generateCode(code, machineReadableCodeObjectType: type) {
                return RSAbstractCodeGenerator.resizeImage(image, targetSize: imageSize, contentMode: .scaleAspectFill)!
            }
        }

        return nil
    }
    
    class func generateQRCodeFrom(stringCode code: String, withImageSize imageSize: CGSize) -> UIImage? {
        let generator = RSUnifiedCodeGenerator.shared
        generator.fillColor = UIColor.white
        generator.strokeColor = UIColor.black
        
        if let image = generator.generateCode(code, machineReadableCodeObjectType: AVMetadataObjectTypeQRCode) {
            return RSAbstractCodeGenerator.resizeImage(image, targetSize: imageSize, contentMode: .scaleAspectFill)!
        }
        
        return nil
    }
    
    private class func codeDidValidate(_ code: String) -> String? {
        let types = [
                        AVMetadataObjectTypeUPCECode,              AVMetadataObjectTypeCode39Code,     AVMetadataObjectTypeCode39Mod43Code,
                        AVMetadataObjectTypeEAN13Code,             AVMetadataObjectTypeEAN8Code,       AVMetadataObjectTypeCode93Code,
                        AVMetadataObjectTypeCode128Code,           AVMetadataObjectTypePDF417Code,     AVMetadataObjectTypeAztecCode,
                        AVMetadataObjectTypeInterleaved2of5Code,   AVMetadataObjectTypeITF14Code,      AVMetadataObjectTypeDataMatrixCode
                    ]
        
        for type in types {
            if (RSUnifiedCodeValidator.shared.isValid(code, machineReadableCodeObjectType: type) == true) {
                return type
            }
        }
        
        return nil
    }
}
