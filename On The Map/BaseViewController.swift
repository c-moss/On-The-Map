//
//  BaseViewController.swift
//  On The Map
//
//  Created by Campbell Moss on 3/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    func showErrorAlert(title: String? = "Error", message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let errorAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {(UIAlertAction) in
                errorAlert.dismissViewControllerAnimated(true, completion: nil)
            }
            errorAlert.addAction(action)

            self.presentViewController(errorAlert, animated: true, completion: nil)
        }
    }
    
    // Utility function for checking that a string is both non-nil and non-empty
    func hasData(str: String?) -> Bool {
        return (str == nil) ? false: str!.characters.count > 0
    }
    
    // Reloads the data displayed by this controller. 
    //TODO: move to subclass for List and Map views
    func reloadData() {
        //to be overridden by subclasses
    }
    
    func showLoadingIndicator() {
        dispatch_async(dispatch_get_main_queue()) {
            self.spinner.center = self.view.center
            self.spinner.startAnimating()
            self.view.addSubview(self.spinner)
        }
    }
    
    func hideLoadingIndicator() {
        dispatch_async(dispatch_get_main_queue()) {
            self.spinner.removeFromSuperview()
        }
    }
    
    
}
