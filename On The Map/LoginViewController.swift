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
                print(error)
                self.showErrorAlert(message: "There was an error logging in. Please try again")
                //TODO: differentiate between incorrect credentials and other errors
                return
            }
            
            guard let result = result else {
                print("No result returned")
                return
            }
            
            print("Success!: \(result)")
            
        }
        //performSegueWithIdentifier("login", sender: self)
    }
    
}
