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
    var exitLoadingTask: (() -> Void)?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func hideKeyboard(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func showErrorAlert(title: String? = "Error", message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            if self.exitLoadingTask != nil {
                self.exitLoadingState()
            }
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
    
    func enterLoadingState(enterLoadingTask: () -> Void, exitLoadingTask: () -> Void) {
        self.exitLoadingTask = exitLoadingTask
        dispatch_async(dispatch_get_main_queue()) {
            self.spinner.center = self.view.center
            self.spinner.startAnimating()
            self.view.addSubview(self.spinner)
            enterLoadingTask()
        }
    }
    
    func exitLoadingState() {
        dispatch_async(dispatch_get_main_queue()) {
            if let task = self.exitLoadingTask {
                task()
            }
            self.spinner.removeFromSuperview()
            self.spinner.stopAnimating()
        }
    }
}

protocol DataViewController {
    // Reloads the data displayed by this controller.
    func reloadData()
}