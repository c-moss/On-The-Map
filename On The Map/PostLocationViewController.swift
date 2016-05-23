//
//  PostLocationViewController.swift
//  On The Map
//
//  Created by Campbell Moss on 17/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: BaseViewController, UITextViewDelegate {
    
    // MARK: First location view
    @IBOutlet weak var locationEntryView: UIView!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var locationPlaceholder: UILabel!
    @IBOutlet weak var findButton: UIButton!
    
    // MARK: Second location view
    @IBOutlet weak var locationDetailView: UIView!
    @IBOutlet weak var linkTextView: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        findButton.layer.cornerRadius = 10
        submitButton.layer.cornerRadius = 10
        
        resetUI()
    }
    
    // MARK: fake placeholder for UITextView
    func textViewDidBeginEditing(textView: UITextView) {
        locationPlaceholder.hidden = true
    }
    func textViewDidEndEditing(textView: UITextView) {
        locationPlaceholder.hidden = textView.hasText()
    }
    
    @IBAction func cancelButtonClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findButtonClicked(sender: UIButton) {
        guard let searchQuery = locationTextView.text where !searchQuery.isEmpty else {
            self.showErrorAlert(message: "Please enter a location search term")
            return
        }
        
        let mapSearchRequest = MKLocalSearchRequest()
        mapSearchRequest.naturalLanguageQuery = searchQuery
        
        enterLoadingState {
            self.locationTextView.editable = false
            self.findButton.enabled = false
        }
        
        let mapSearch = MKLocalSearch(request: mapSearchRequest)
        mapSearch.startWithCompletionHandler { (response, error) in
            self.exitLoadingState {
                self.locationTextView.editable = true
                self.findButton.enabled = true
            }
            guard error == nil else {
                print("Map search error: \(error)")
                self.showErrorAlert(message: "Could not complete location search - please try again")
                return
            }
            
            guard let response = response else {
                print("No search response returned")
                self.showErrorAlert(message: "Could not complete location search - please try again")
                return
            }
            
            guard !response.mapItems.isEmpty else {
                print("No search results returned")
                self.showErrorAlert(message: "No results returned - please try again")
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.pinMapAndZoom(response.mapItems[0])
                self.locationEntryView.hidden = true
                self.locationDetailView.hidden = false
                }
        }
    }
    
    @IBAction func submitButtonClicked(sender: UIButton) {
        guard let link = linkTextView.text where !link.isEmpty else {
            self.showErrorAlert(message: "Please enter a link")
            return
        }
        
        let model = Model.sharedInstance()
        
        //let location = StudentInformation(objectId: nil, uniqueKey: "1234", firstName: , lastName: "o", mapString: <#T##String#>, mediaURL: <#T##String#>, latitude: <#T##Float#>, longitude: <#T##Float#>, createdAt: <#T##NSDate?#>, updatedAt: <#T##NSDate?#>)
    }
    
    // Add an annotation pin to the mapView and zoom to show that pin
    private func pinMapAndZoom(mapItem: MKMapItem) {
        self.mapView.addAnnotation(mapItem.placemark)
        
        let zoomRegion = MKCoordinateRegionMake(mapItem.placemark.coordinate, MKCoordinateSpanMake(5, 5))
        mapView.setRegion(zoomRegion, animated: false)
    }
    
    // Reset the UI state
    private func resetUI() {
        locationEntryView.hidden = false
        locationDetailView.hidden = true
        locationTextView.text = ""
        mapView.removeAnnotations(mapView.annotations)
    }
}
