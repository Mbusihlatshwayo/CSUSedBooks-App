//
//  ViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/18/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.


import UIKit

var isLinkedWithFB: Bool = PFFacebookUtils.isLinkedWithUser(PFUser.currentUser())

var name = ""

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView() // displays loading circle
    
    // displays the error for log in
    func displayAlert(title: String, error: String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)

        
    }
    
    var signUpActive = true
    
    var permissions = ["public_profile"]
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var signUpButton: UIButton!
    
    @IBOutlet var alreadyRegistered: UILabel!
    
    @IBOutlet var logInButton: UIButton!
    
    
    // switches text around if the user needs to log in or sighn up
    @IBAction func logIn(sender: AnyObject) {
        
        if (signUpActive == true) {
        
            signUpActive = false
            
            signUpButton.setTitle("Log In", forState: UIControlState.Normal)
        
            alreadyRegistered.text = "Not Registered?"
        
            logInButton.setTitle("Sign Up", forState: UIControlState.Normal)
        } else {
            
            signUpActive = true
            
            signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            alreadyRegistered.text = "Already Registered?"
            
            logInButton.setTitle("Log In", forState: UIControlState.Normal)

            
        }
        
    }
    
    // signs the user in with parse
    @IBAction func signUp(sender: AnyObject) {
        
        var error = ""
        
        if (username.text == "" || password.text == "") {
            
            error = "Please enter a username and password"
            
        } else if (password.text.utf16Count < 6) {
            
            error = "Passwords must be more than 5 characters"
            
        }
        
        
        if (error != "") {
            
            displayAlert("Sign Up Error", error: error)
            
            
        } else {
            
            
            let actIndPoint = CGPointMake(self.view.center.x, self.view.center.y - 50 )
            
            self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            self.activityIndicator.center = actIndPoint
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            if (signUpActive == true) {
                
                // create the user object
                var user = PFUser()
                user.username = username.text
                user.password = password.text
                
                // sign the user in with parse
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool!, signUpError: NSError!) -> Void in
                
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                    if (signUpError == nil && PFUser.currentUser() != nil) {
                    
                        // lets the user recieve push notifications sent to their username
                        let currentInstallation = PFInstallation.currentInstallation()
                        currentInstallation.addUniqueObject(PFUser.currentUser().username, forKey: "channels")
                        currentInstallation.saveInBackground()
                        
                        self.performSegueWithIdentifier("jumpToListingsTable", sender: self)
                        
                        
                    } else {
                    
                        // creates the error
                        if let errorString = signUpError.userInfo?["error"] as? NSString {
                        
                            error = errorString
                        
                        } else {
                        
                            error = "Please try again later."
                        
                        }
                    
                        self.displayAlert("Could not sign up", error: error)
                      
                    }
                    
                }
            } else {
                
                // user has an account log them in
                PFUser.logInWithUsernameInBackground(username.text, password: password.text) {
                    
                    (user: PFUser!, signUpError: NSError!) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if (signUpError == nil) {
                        
                        if (PFUser.currentUser() != nil) {
                      
                            self.performSegueWithIdentifier("jumpToListingsTable", sender: self)
                            
        
                                let currentInstallation = PFInstallation.currentInstallation()
                                currentInstallation.addUniqueObject(PFUser.currentUser().username, forKey: "channels")
                                currentInstallation.saveInBackground()
                            
                        }

                        
                        
                    } else {
                        
                        // create the error
                        if let errorString = signUpError.userInfo?["error"] as? NSString {
                            
                            error = errorString
                            
                        } else {
                            
                            error = "Please try again later."
                            
                        }
                        
                        self.displayAlert("Could not log in", error: error)
                        
                    }
                }
                
            }
            
        }
        
    }
    
    
    @IBAction func signUpWithFacebook(sender: AnyObject) {
        
        self.view.addSubview(self.activityIndicator)
        
        var user1 = PFUser()
        
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            
            if let user1 = user {
                
                if user1.isNew {
                    
                    // user is new sign them up with facebook
                    
                    isLinkedWithFB = true
                    
                    // user recieves notifications for their unique username
                    let currentInstallation = PFInstallation.currentInstallation()
                    currentInstallation.addUniqueObject(PFUser.currentUser().username, forKey: "channels")
                    currentInstallation.saveInBackground()
                    
                    self.performSegueWithIdentifier("jumpToListingsTable", sender: self)
                    
                } else {
                    
                    // user logged in with facebook
                    
                    isLinkedWithFB = true
                    
                    // user recieves notifications for their unique username
                    let currentInstallation = PFInstallation.currentInstallation()
                    currentInstallation.addUniqueObject(PFUser.currentUser().username, forKey: "channels")
                    currentInstallation.saveInBackground()
                    
                    self.performSegueWithIdentifier("jumpToListingsTable", sender: self)
                    
                }
                
            }
            
        })
        
        
        
        if (isLinkedWithFB) {
            
            // if the user is linked with facebook get their first name
            FBRequestConnection.startForMeWithCompletionHandler({ (connection, result, error) -> Void in
                
                
                // Cast result to optional dictionary type
                var resultdict = result as? NSDictionary
                
                if (resultdict != nil) {
                    // Extract a value from the dictionary
                    name = resultdict!["first_name"] as String
            
                }
                
            })
            
        }
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        username.resignFirstResponder()
        password.resignFirstResponder()
        return true
        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        username.delegate = self
        password.delegate = self
        
        if (isLinkedWithFB) {
            
            FBRequestConnection.startForMeWithCompletionHandler({ (connection, result, error) -> Void in
                
                               // Cast result to optional dictionary type
                var resultdict = result as? NSDictionary
                
                if (resultdict != nil) {
                    // Extract a value from the dictionary
                    name = resultdict!["first_name"] as String
                    
                }
                
            })
            
        }
        
    }

    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(true)
        
        if (PFUser.currentUser() != nil) {
        
            self.performSegueWithIdentifier("jumpToListingsTable", sender: self)
         
            // user recieves notifications for their unique username
            let currentInstallation = PFInstallation.currentInstallation()
            currentInstallation.addUniqueObject(PFUser.currentUser().username, forKey: "channels")
            currentInstallation.saveInBackground()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
