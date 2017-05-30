//
//  BarcodeReaderShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import AVFoundation
import RSBarcodes_Swift

class BarcodeReaderViewController: RSCodeReaderViewController {
    // MARK: - Properties
//    var barcode: String = ""
    var dispatched: Bool = false
    
    var handlerReadBarcodeCompletion: HandlerPassDataCompletion?

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard (AVCaptureDevice.devices().filter({ ($0 as AnyObject).position == .front })
            .first as? AVCaptureDevice) != nil else {
                self.alertViewDidShow(withTitle: "Error", andMessage: "Camera is not available", completion: { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                
                return
        }
        
        // MARK: NOTE: Uncomment the following line to enable crazy mode
        // self.isCrazyMode = true
        
        self.focusMarkLayer.strokeColor = UIColor.red.cgColor
        self.cornersLayer.strokeColor = UIColor.yellow.cgColor
        
        self.tapHandler = { point in
            print(point)
        }
        
        // MARK: NOTE: If you want to detect specific barcode types, you should update the types
        let types = NSMutableArray(array: self.output.availableMetadataObjectTypes)
        
        // MARK: NOTE: Uncomment the following line remove QRCode scanning capability
        // types.removeObject(AVMetadataObjectTypeQRCode)
        
        self.output.metadataObjectTypes = NSArray(array: types) as [AnyObject]
        
        // MARK: NOTE: If you layout views in storyboard, you should these 3 lines
        for subview in self.view.subviews {
            self.view.bringSubview(toFront: subview)
        }
        
        // Handler check any type code
        self.barcodesHandler = { barcodes in
            // Triggers for only once
            if !self.dispatched {
                self.dispatched = true
               
                for barcode in barcodes {
//                    self.barcode = barcode.stringValue
//                    print("Barcode found: type=" + barcode.type + " value=" + barcode.stringValue)
//                    
                    DispatchQueue.main.async(execute: {
                        self.handlerReadBarcodeCompletion!(barcode)
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                    // MARK: NOTE: break here to only handle the first barcode object
                    break
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dispatched = false // reset the flag so user can do another scan
        
        super.viewWillAppear(animated)
        
        if let navigationController = self.navigationController {
            navigationController.isNavigationBarHidden = true
        }
    }    
}
