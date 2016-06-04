//
//  MainTabBarController.swift
//  On The Map
//
//  Created by Campbell Moss on 17/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func refreshClicked(sender: UIBarButtonItem) {
        if let currentView = self.selectedViewController as! BaseViewController! {
            currentView.enterLoadingState {
                sender.enabled = false
            }
            ParseClient.sharedInstance().getStudentLocations() { (result, error) in
                currentView.exitLoadingState {
                    sender.enabled = true
                }
                
                if error != nil {
                    print(error)
                    //TODO: handle this error better - kick back to login screen?
                    currentView.showErrorAlert(message: "There was an retrieving student location data. Please try again")
                    return
                }
                
                guard let result = result else {
                    print("No result returned")
                    currentView.showErrorAlert(message: "There was an retrieving student location data. Please try again")
                    return
                }
                
                Model.sharedInstance().studentInformationData = result
                (currentView as! DataViewController).reloadData()
            }
        }
    }
}