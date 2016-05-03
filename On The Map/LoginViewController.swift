//
//  LoginViewController.swift
//  On The Map
//
//  Created by Campbell Moss on 2/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(sender: UIButton) {
        UdacityClient.sharedInstance().createSession("campbell.moss@gmail.com", password: "monkeybrains") { (result, error) in
            if error != nil {
                print("There was error sir: \(error)")
                return //TODO: Display error to user
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
