//
//  LoginViewController.swift
//  On The Map
//
//  Created by Campbell Moss on 2/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let gradient:CAGradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor(red: 0.992, green: 0.525, blue: 0.055, alpha: 1.0).CGColor, UIColor(red: 0.984, green: 0.345, blue: 0.035, alpha: 1.0).CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
        loginButton.layer.cornerRadius = 5
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradient.frame = self.view.bounds
        CATransaction.commit()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == usernameField) {
            passwordField.becomeFirstResponder()
        } else if (textField == passwordField) {
            passwordField.resignFirstResponder()
            loginPressed(loginButton)
        }
        return true
    }
    
    @IBAction func loginPressed(sender: UIButton) {
        let username = usernameField.text
        let password = passwordField.text
        guard hasData(username) && hasData(password) else {
            showErrorAlert("Invalid credentials", message: "Please enter username and password")
            return
        }
        
        enterLoadingState({
                self.usernameField.enabled = false
                self.passwordField.enabled = false
                self.loginButton.enabled = false
            }, exitLoadingTask: {
                self.usernameField.enabled = true
                self.passwordField.enabled = true
                self.loginButton.enabled = true
            })
        
        self.createSession(username!, password: password!) { (success) in
            if (success) {
                self.getUserInformation { (success) in
                    if (success) {
                        self.getStudentLocations { (success) in
                            self.exitLoadingState()
                            if (success) {
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.performSegueWithIdentifier("login", sender: self)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func signUpPressed(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    
    private func createSession(username: String, password: String, completion: (Bool) -> Void) {
        UdacityClient.sharedInstance().createSession(username, password: password) { (result, error) in
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
                completion(false)
                return
            }
            
            guard let result = result else {
                print("No result returned")
                completion(false)
                return
            }
            
            Model.sharedInstance().sessionData = result
            
            completion(true)
        }
    }
    
    private func getUserInformation(completion: (Bool) -> Void) {
        guard let accountKey = Model.sharedInstance().sessionData?.account.key else {
            print("Error: Udacity session model does not contain account key: \(Model.sharedInstance().sessionData)")
            self.showErrorAlert(message: "There was an error logging in. Please try again")
            completion(false)
            return
        }
        UdacityClient.sharedInstance().getUserInformation(accountKey) { (result, error) in
            if error != nil {
                print(error)
                self.showErrorAlert(message: "There was an retrieving user data. Please try again")
                completion(false)
                return
            }
            
            guard let result = result else {
                print("No result returned")
                self.showErrorAlert(message: "There was an retrieving user data. Please try again")
                completion(false)
                return
            }
            
            Model.sharedInstance().userData = result
            
            completion(true)
        }
    }
    
    private func getStudentLocations(completion: (Bool) -> Void) {
        ParseClient.sharedInstance().getStudentLocations() { (result, error) in
            if error != nil {
                print(error)
                self.showErrorAlert(message: "There was an retrieving student location data. Please try again")
                completion(false)
                return
            }
            
            guard let result = result else {
                print("No result returned")
                self.showErrorAlert(message: "There was an retrieving student location data. Please try again")
                completion(false)
                return
            }
            
            Model.sharedInstance().studentInformationData = result
            
            completion(true)
        }
    }
    
    private func resetForm() {
        usernameField.text = nil
        passwordField.text = nil
    }
    
    @IBAction func logout(segue:UIStoryboardSegue) {
        resetForm()
        Model.sharedInstance().sessionData = nil

        UdacityClient.sharedInstance().deleteSession() { (result, error) in
            if error != nil {
                print(error)
                self.showErrorAlert(message: "There was an error logging out")
                return
            }
        }
    }
    
}
