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
    
    var location: MKMapItem!
    
    override func viewWillAppear(animated: Bool) {
        findButton.layer.cornerRadius = 10
        submitButton.layer.cornerRadius = 10
        
        location = nil
        
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
        
        enterLoadingState({
                self.locationTextView.editable = false
                self.findButton.enabled = false
            }, exitLoadingTask: {
                self.locationTextView.editable = true
                self.findButton.enabled = true
            })
        
        let mapSearch = MKLocalSearch(request: mapSearchRequest)
        mapSearch.startWithCompletionHandler { (response, error) in
            self.exitLoadingState()
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
            
            self.location = response.mapItems[0]
            
            dispatch_async(dispatch_get_main_queue()) {
                self.pinMapAndZoom(self.location)
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
        
        guard let mapString = locationTextView.text where !mapString.isEmpty else {
            print("Error: location search string was null when posting location")
            self.showErrorAlert(message: "Please enter a location to search for and retry")
            return
        }
        
        guard let latitude = self.location.placemark.location?.coordinate.latitude,
            let longitude = self.location.placemark.location?.coordinate.longitude else {
                print("Error: Could not access location coordinates")
                self.showErrorAlert(message: "Please retry location search")
                return
        }
        
        let model = Model.sharedInstance()
        let parseClient = ParseClient.sharedInstance()
        
        enterLoadingState({
                self.submitButton.enabled = false
                self.linkTextView.enabled = false
            }, exitLoadingTask: {
                self.submitButton.enabled = true
                self.linkTextView.enabled = true
            })
        
        // Query for an existing student location with the specified account key
        parseClient.queryStudentLocation(model.sessionData!.account.key) { (result, error) in
            
            guard error == nil else {
                print("Error querying student location: \(error)")
                self.showErrorAlert(message: "Could not post your location - please try again")
                return
            }
            
            guard let result = result else {
                print("No result object from querying student location")
                self.showErrorAlert(message: "Could not post your location - please try again")
                return
            }
            
            var submitLocationFunction: (StudentInformation, (result: StudentInformation?, error: Error?) -> Void) -> Void
            var location: StudentInformation
            
            if result.isEmpty { // if no existing locations were found, POST a new one
                submitLocationFunction = parseClient.postStudentLocation
                location = StudentInformation(objectId: nil, uniqueKey: model.sessionData!.account.key, firstName: model.userData!.firstName, lastName: model.userData!.lastName, mapString: mapString, mediaURL: link, latitude: latitude, longitude: longitude)
            } else {    // if an existing location was found, PUT an update to it
                submitLocationFunction = parseClient.updateStudentLocation
                location = result[0]
                location.mapString = mapString
                location.mediaURL = link
                location.latitude = latitude
                location.longitude = longitude
            }
            
            //Submit the location
            submitLocationFunction(location) { (result, error) in
                guard error == nil else {
                    print("Error submitting student location: \(error)")
                    self.showErrorAlert(message: "Could not submit your location - please try again")
                    return
                }
                
                ParseClient.sharedInstance().getStudentLocations() { (result, error) in
                    self.exitLoadingState()
                    
                    if error != nil {
                        print(error)
                        //TODO: handle this error better - kick back to login screen?
                        self.showErrorAlert(message: "There was an retrieving student location data. Please try again")
                        return
                    }
                    
                    guard let result = result else {
                        print("No result returned")
                        self.showErrorAlert(message: "There was an retrieving student location data. Please try again")
                        return
                    }
                    
                    Model.sharedInstance().studentInformationData = result
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
        }
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
