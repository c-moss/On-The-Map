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
        studentInformationData = Model.sharedInstance().studentInformationData!
        dispatch_async(dispatch_get_main_queue()) {
            self.mapView.removeAnnotations(self.mapView.annotations)
            for student in self.studentInformationData {
                let mapAnnotation = StudentAnnotation(student: student)
                self.mapView.addAnnotation(mapAnnotation)
            }
            self.mapView.setNeedsDisplay()
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let accessoryButton = UIButton(type: UIButtonType.DetailDisclosure)
        accessoryButton.userInteractionEnabled = false
        let mapAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "loc")
        mapAnnotationView.canShowCallout = true
        mapAnnotationView.rightCalloutAccessoryView = accessoryButton
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

