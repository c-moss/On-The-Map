//
//  MapViewController.swift
//  On The Map
//
//  Created by Campbell Moss on 1/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController, DataViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var studentInformationData = Model.sharedInstance().studentInformationData!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadData()
    }
    
    func reloadData() {
        for student in studentInformationData {
            let mapAnnotation = StudentAnnotation(student: student)
            self.mapView.addAnnotation(mapAnnotation)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let mapAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "loc")
        mapAnnotationView.canShowCallout = true
        mapAnnotationView.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
        //TODO: figure out how to send clicks on the accessory view button to the callout gesture recognizer
        return mapAnnotationView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        //add a tap gesture recognizer so that taps on the callout can be detected
        //TODO: upgrade to XCode 7.3 and use the new #selector syntax
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "calloutTapped:")
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Remove gesture recognizers when the annotation view is deselected so that they don't get triggered next time it gets tapped
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        for gestureRecognizer in view.gestureRecognizers! {
            view.removeGestureRecognizer(gestureRecognizer)
        }
    }
    
    //function to handle an annotation callout being tapped
    func calloutTapped(sender: UITapGestureRecognizer) {
        let annotation = (sender.view as! MKAnnotationView).annotation as! StudentAnnotation
        guard let url = annotation.student.validatedURL else {
            showErrorAlert(message: "Invalid URL: \(annotation.student.mediaURL)")
            print("Could not convert \(annotation.student.mediaURL) to an NSURL")
            return
        }
        UIApplication.sharedApplication().openURL(url)
    }
}

