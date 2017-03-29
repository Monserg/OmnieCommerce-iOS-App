//
//  OrganizationsMapShowViewController.swift
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

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol OrganizationsMapShowViewControllerInput {
    func pointAnnotationsDidShow(fromViewModel viewModel: OrganizationsMapShowModels.PointAnnotations.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol OrganizationsMapShowViewControllerOutput {
    func pointAnnotationsDidLoad(withRequestModel requestModel: OrganizationsMapShowModels.PointAnnotations.RequestModel)
}

class OrganizationsMapShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: OrganizationsMapShowViewControllerOutput!
    var router: OrganizationsMapShowRouter!
    
    var items = [PointAnnotationBinding]()
    var pointAnnotations = [PointAnnotation]()
    var regionRect = MKMapRect()

    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    
    // Info view
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var cityLabel: CustomLabel!
    @IBOutlet weak var streetLabel: CustomLabel!

    @IBOutlet weak var mapView: MapView! {
        didSet {
            // Delegates
            mapView.delegate = self
            
            // Customize map view
            mapView.showsScale = true
            mapView.showsCompass = true
        }
    }
    

    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        OrganizationsMapShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.startAnimating()
        
        viewSettingsDidLoad()
    }
    

    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        spinnerDidStart(mapView)
        
        // Config smallTopBarView
        navigationBarView = smallTopBarView
        smallTopBarView.type = "Child"
        haveMenuItem = false
        
        // Handler Back button tap
        smallTopBarView.handlerSendButtonCompletion = { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        if (items.count == 1) {
            infoView.isHidden = false
            cityLabel.text = items.first!.addressCity
            streetLabel.text = items.first!.addressStreet
        } else {
            infoView.isHidden = true
        }
        
        // Load point annotations
        let requestModel = OrganizationsMapShowModels.PointAnnotations.RequestModel(items: items)
        interactor.pointAnnotationsDidLoad(withRequestModel: requestModel)
    }
    
    func mapViewDidAddPointAnnotations() {
        mapView.addAnnotations(pointAnnotations)
        mapView.showAnnotations(pointAnnotations, animated: true)
        regionRect = mapView.mapRectThatFits(regionRect, edgePadding: UIEdgeInsetsMake(20, 50, 20, 50))
        mapView.setVisibleMapRect(regionRect, animated: true)
    }
    
    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        mapView.setNeedsDisplay()
    }
}


// MARK: - OrganizationsMapShowViewControllerInput
extension OrganizationsMapShowViewController: OrganizationsMapShowViewControllerInput {
    func pointAnnotationsDidShow(fromViewModel viewModel: OrganizationsMapShowModels.PointAnnotations.ViewModel) {
        spinnerDidFinish()
        
        self.pointAnnotations = viewModel.pointAnnotations
        self.regionRect = viewModel.regionRect
        self.mapViewDidAddPointAnnotations()
    }
}


// MARK: - MKMapViewDelegate
extension OrganizationsMapShowViewController: MKMapViewDelegate {
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        if (fullyRendered) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            spinner.stopAnimating()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinIdentifier = "Pin"
        var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdentifier) as? MKPinAnnotationView
        
        if (pinAnnotationView != nil) {
            pinAnnotationView!.annotation = annotation
        } else {
            pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
            pinAnnotationView!.pinTintColor = UIColor.init(hexString: "#009395", withAlpha: 1.0)
        }
        
        pinAnnotationView!.canShowCallout = false
        pinAnnotationView!.isDraggable = true
        
        /*
        // Add button
        let detailButton                                    =   UIButton(type: .detailDisclosure)
        pinAnnotationView!.rightCalloutAccessoryView        =   detailButton
        
        // Add organization image
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 44, height: 33))
        
        guard let avatar                                    =   (annotation as! PointAnnotation).image else {
            leftIconView.image                              =   UIImage(named: "image-no-organization")
            leftIconView.backgroundColor                    =   UIColor.veryLightGray
            pinAnnotationView!.leftCalloutAccessoryView     =   leftIconView
            
            return pinAnnotationView
        }
        
        leftIconView.image                                  =   avatar
        pinAnnotationView!.leftCalloutAccessoryView         =   leftIconView
        */
        
        return pinAnnotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.canShowCallout = true
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Hide the callout view.
        mapView.deselectAnnotation(view.annotation, animated: true)
       
        let annotation = view.annotation as! PointAnnotation
        let index = pointAnnotations.index(of: annotation)!
        let item = items[index]
        
        router.navigateToItemShowScene(withItem: item)
    }
}
