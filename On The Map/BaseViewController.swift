//
//  BaseViewController.swift
//  On The Map
//
//  Created by Campbell Moss on 3/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
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
    
    func hasData(str: String?) -> Bool {
        return (str == nil) ? false: str!.characters.count > 0
    }
    
    func reloadData() {
        //to be overridden by subclasses
    }
    
}
