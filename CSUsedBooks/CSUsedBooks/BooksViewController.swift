//
//  BooksViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/20/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

var pickedSubject = "Accounting"
var bookGUID = ""

class BooksViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate , UINavigationControllerDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {

    
    @IBOutlet var bookImage: UIImageView!
    @IBOutlet var coursePicker: UIPickerView!
    @IBOutlet var bookDescription: UITextField!
    
    @IBOutlet var sellView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    var photoSelected = false
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var tapGesture = UITapGestureRecognizer()
    
    func tapTextView(sender:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func pickImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    
    @IBAction func postListing(sender: AnyObject) {
        
        var error = ""
        
        bookGUID = NSUUID().UUIDString

        
        if (photoSelected == false) {
         
            error = "Please select an image."
            
        } else if (bookDescription.text == "") {
            
            error = "Please enter a description scroll down."
            
        } else if (pickedSubject == "") {
            
            error = "Please pick a subject."
            
        }
        
        if (error != "") {
            
            displayAlert("Can't Post Image", error: error)
            
        } else {
            
            
            let actIndPoint = CGPointMake(self.view.center.x, self.view.center.y)
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = actIndPoint
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(self.activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var bookPosting = PFObject(className: "BookPosting")
            
            if (isLinkedWithFB) {
                
                bookPosting["Description"] = bookDescription.text
                bookPosting["username"] = name
                bookPosting["CourseSubject"] = pickedSubject
                bookPosting["GUID"] = bookGUID
                bookPosting["realUsername"] = PFUser.currentUser()!.username
                
            } else {
               
                bookPosting["Description"] = bookDescription.text
                bookPosting["username"] = PFUser.currentUser()!.username
                bookPosting["CourseSubject"] = pickedSubject
                bookPosting["GUID"] = bookGUID
                bookPosting["realUsername"] = PFUser.currentUser()!.username
                
            }
            
            bookPosting.saveInBackgroundWithBlock({ (success, error) -> Void in
            
                
                if (success == false) {
                    
                    self.displayAlert("Can't Post Image", error: "Please try again")
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                } else {
                    
                    let imageData = UIImageJPEGRepresentation(self.bookImage.image, 1.0)
                    
                    let imageFile = PFFile(name: "image.jpg", data: imageData)
                    if imageData == nil {
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        self.displayAlert("Can't post image", error: "error converting image")
                        
                    }
                    
                    bookPosting["imageFile"] = imageFile
                    
                    bookPosting.saveInBackgroundWithBlock({ (success, error) -> Void in
                        
                        if (success == false) {
                            
                            self.displayAlert("Can't Post Image", error: "Please try again")
                            
                            self.activityIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                        } else {
                            
                            self.activityIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                            self.displayAlert("Your image has been posted", error: "Posted Successfully")
                            
                            self.photoSelected = false
                            
                            self.bookImage.image = UIImage(named: "book1.png")
                            
                            self.bookDescription.text = ""
                            
                        }
                        
                    })
                    
                }
                
            })
            
            
        }
        
    }
    
    func displayAlert(title: String, error: String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        bookImage.image = image
        photoSelected = true
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return courseCatalog.count
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return courseCatalog[row]
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickedSubject = courseCatalog[row]
        
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        tapGesture = UITapGestureRecognizer(target: self, action: "tapTextView:")
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        bookDescription.delegate = self
        scrollView.delegate = self
        scrollView.addSubview(sellView)
        scrollView.contentSize = CGSizeMake(0,550)
        
        photoSelected = false
        
        bookImage.image = UIImage(named: "book1.png")
        
        bookDescription.text = ""
      
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        
        unreadMessages.removeAll(keepCapacity: false)
        
        // update the badge if the user has mail in the mailbox unred
        var tabArray = self.tabBarController?.tabBar.items as NSArray!
        var tabItem = tabArray.objectAtIndex(1) as! UITabBarItem
        
        var unreadQuery = PFQuery(className: "Message")
        unreadQuery.whereKey("realToUser", equalTo: PFUser.currentUser()!.username!)
        
        unreadQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            // set messages to read here
            
            if error == nil {
                
                // The find succeeded.
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    
                    for object in objects {
                        
                        if (object["readStatus"] != nil) {
                            
                            var read = Bool()
                            if (object["readStatus"] as! String == "no") {
                                
                                unreadMessages.append("read")
                                
                            }
                            
                        }
                        
                    }

                    tabBarBadge = unreadMessages.count
                    if (unreadMessages.count == 0) {
                        
                        tabItem.badgeValue = nil
                        
                    } else {
                        
                        tabItem.badgeValue = String(unreadMessages.count)
                        
                    }
                }
                
            } else {
                
                // Log details of the failure
                println("Error: \(error) \(error!.userInfo!)")
                
            }
            
        }

    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        bookDescription.resignFirstResponder()
        return true
    }
}
