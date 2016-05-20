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
    
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var locationPlaceholder: UILabel!
    
    @IBOutlet weak var locationTextView: UITextView!
    
    @IBOutlet weak var locationEntryView: UIView!
    @IBOutlet weak var locationDetailView: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(animated: Bool) {
        findButton.layer.cornerRadius = 10
        submitButton.layer.cornerRadius = 10
        
        
        locationEntryView.hidden = false
        locationDetailView.hidden = true
        locationTextView.text = ""
    }
    
    //MARK: fake placeholder for UITextView
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
        locationEntryView.hidden = true
        locationDetailView.hidden = false
    }
}