//
//  PersonalPageShowWorker.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import CoreLocation

class PersonalPageShowWorker {
    // MARK: - Custom Functions. Business Logic
    func userAppTemplatesDidLoad(forUserApp userAppCode: String) -> [Organization]? {
        guard arc4random_uniform(2) == 1 else {
            return nil
        }
        
        var items   =   [Organization]()
        
        for index in 0..<11 {
            let organization = Organization(codeID: "\(index)",
                                            name: "Organization \(index)",
                                            category: Category.init(),
                                            rating: Double(arc4random_uniform(6)),
                                            isFavorite: false,
                                            logoURL: "http://vignette2.wikia.nocookie.net/logopedia/images/2/25/BMW_logo.png/revision/latest?cb=20150410110027")
            
            items.append(organization)
        }

        return items
    }

    func userAppDidUpdateOnServer(withParameters parameters: [String: String]) -> AppUser {
        // NOTE: Do the work
        return CoreDataManager.instance.appUser
    }
}
