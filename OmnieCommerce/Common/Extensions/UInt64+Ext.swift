//
//  UInt64+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 18.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation

extension UInt64 {
    func encodeToParameters() -> [String: Int] {
        let day = Int(self / UInt64(86_400))
        let hours = Int((self - UInt64(day * 86_400)) / UInt64(3_600))
        let minutes = Int((self - UInt64(day * 86_400) - UInt64(hours * 3_600)) / UInt64(60))
        
        return [ "day": day, "hours": hours, "minutes": minutes ]
    }
    
    static func decodeToNumber(fromParameters parameters: [String: Int]) -> UInt64 {
        let day = UInt64(parameters["day"]! * 86_400)
        let hours = UInt64(parameters["hours"]! * 3_600)
        let minutes = UInt64(parameters["minutes"]! * 60)
        
        return day + hours + minutes
    }
    
    func millisecondsConvertToMinutes() -> Int32 {
        return Int32(self / 1_000 / 60 / 60)
    }    
}
