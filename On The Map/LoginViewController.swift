//
//  LoginViewController.swift
//  On The Map
//
//  Created by Campbell Moss on 2/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(sender: UIButton) {
        let username = usernameField.text
        let password = passwordField.text
        guard hasData(username) && hasData(password) else {
            showErrorAlert("Invalid credentials", message: "Please enter username and password")
            return
        }
        
        UdacityClient.sharedInstance().createSession(username!, password: password!) { (result, error) in
            if error != nil {
                if let statusCode = (error as? HTTPError)?.code {
                    switch statusCode {
                    case 403:
                        self.showErrorAlert(message: "Incorrect username or password supplied - please try again")
                        break
                    default:
                        print(error)
                        self.showErrorAlert(message: "There was an error logging in. Please try again")
                    }
                } else {
                    print(error)
                    self.showErrorAlert(message: "There was an error logging in. Please try again")
                }
                return
            }
            
            guard let result = result else {
                print("No result returned")
                return
            }
            
            Model.sharedInstance().sessionData = result
            
            ParseClient.sharedInstance().getStudentLocations() { (result, error) in
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
                    self.performSegueWithIdentifier("login", sender: self)
                }

            }
        }
    }
    
}
