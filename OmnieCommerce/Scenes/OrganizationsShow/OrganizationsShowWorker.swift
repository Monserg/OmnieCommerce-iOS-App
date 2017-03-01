//
//  OrganizationsShowWorker.swift
//  OmnieCommerce
//
//  Created by msm72 on 23.02.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import MapKit

class OrganizationsShowWorker {
    // MARK: - Properties
    private let locationManager = LocationManager()
    var organizations: [Organization]!
    var handlerLocationCompletion: HandlerLocationCompletion?

    let coordinates = [CLLocationCoordinate2D.init(latitude: 49.439393,             longitude: 26.998901299999943),
                       CLLocationCoordinate2D.init(latitude: 49.422623999124916,    longitude: 26.988609731197357),
                       CLLocationCoordinate2D.init(latitude: 49.424262252764265,    longitude: 27.001497745513916),
                       CLLocationCoordinate2D.init(latitude: 49.383993177221136,    longitude: 27.056922912597656),
                       CLLocationCoordinate2D.init(latitude: 49.39980314570102,     longitude: 26.988601684570312),
                       CLLocationCoordinate2D.init(latitude: 49.39980314570102,     longitude: 26.988601684570312),
                       CLLocationCoordinate2D.init(latitude: 49.39335128197368,     longitude: 26.95422649383545),
                       CLLocationCoordinate2D.init(latitude: 49.410721901425845,    longitude: 26.939420700073242),
                       CLLocationCoordinate2D.init(latitude: 49.40209321384644,     longitude: 26.886205673217773),
                       CLLocationCoordinate2D.init(latitude: 49.42024241465619,     longitude: 26.953754425048828),
                       CLLocationCoordinate2D.init(latitude: 49.42466003133748,     longitude: 26.968055963516235),
                       CLLocationCoordinate2D.init(latitude: 49.44257068157202,     longitude: 26.93126678466797),
                       CLLocationCoordinate2D.init(latitude: 49.45188972576112,     longitude: 27.00765609741211)]
    
    // MARK: - Custom Functions. Business Logic
    func organizationsDidLoad() {
        // Load organizations
        organizations = [Organization]()

        for (index, location) in coordinates.enumerated() {
            let organization = Organization(codeID: index,
                                            name: "Organization \(index)",
                                            location: location,
                                            addressCity: nil,
                                            addressStreet: nil,
                                            logoURL: (Int(arc4random_uniform(2)) == 1) ? "http://vignette2.wikia.nocookie.net/logopedia/images/2/25/BMW_logo.png/revision/latest?cb=20150410110027" : nil,
                                            headerURL: (Int(arc4random_uniform(2)) == 1) ? "http://www.khmelnytskyi-park.com.ua/wp-content/uploads/2016/08/KP6.jpg" : nil,
                                            rating: Double(arc4random_uniform(6)),
                                            isFavorite: (Int(arc4random_uniform(2)) == 1) ? true : false,
                                            phones: phonesDidCreate())
            
            organizations.append(organization)
        }
        
        // Modify organizations: add city & street
        locationManager.startCoreLocation(withOrganizations: organizations)
        locationManager.organizationsDidModify()
        
        locationManager.handlerLocationCompletion = { organizations in
            self.organizations = organizations
            
            self.handlerLocationCompletion!(organizations)
        }
    }
    
    private func phonesDidCreate() -> [String]? {
        var array: [String]?
        let count = Int(arc4random_uniform(3))
        
        if (count > 0) {
            array = [String]()
            
            for _ in 0..<count {
                array!.append("+380671780601")
            }
            
            return array!
        }
        
        return array
    }
    
    func dropDownListDidLoad(withType type: DropDownList) -> [DropDownItem] {
        var dataSource = [DropDownItem]()
        var names: [String]!
        
        switch type {
        case .Services:
            names = ["By services", "By organizations"]

        case .Categories:
            names = ["Всі", "Сауни", "Перукарні", "Бані", "Джакузі", "Спа"]

        default:
            break
        }
        
        for i in 0 ..< names.count {
            dataSource.append(DropDownItem(name: names[i].localized(), codeID: i))
        }
        
        return dataSource
    }
}
