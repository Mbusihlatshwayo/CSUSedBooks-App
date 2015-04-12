//
//  ProfileViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/19/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

var profileImage = UIImagePickerController()

var displayName = "nil"

class ProfileViewController: UIViewController, UITableViewDelegate, UIScrollViewDelegate, FBLoginViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var profileView: UIView!
    
    @IBAction func backToProfileViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBOutlet var profilePictureView: UIImageView!
    
    @IBOutlet var profileTableView: UITableView!
    
    @IBOutlet var usernameLabel: UILabel!
    
    @IBAction func backToProfile(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func goToMailbox(sender: AnyObject) {
        
        self.performSegueWithIdentifier("mailboxSegue", sender: self)
        
    }
    
    @IBAction func logOut(sender: AnyObject) {
        
        PFUser.logOut()
        
        self.performSegueWithIdentifier("loggedOutSegue", sender: self)
        
    }
    
    @IBAction func editProfile(sender: AnyObject) {
        
        self.performSegueWithIdentifier("editSegue", sender: self)
        
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

        if (isLinkedWithFB == true) {
            var FBSession = PFFacebookUtils.session()
            var accessToken = FBSession!.accessTokenData.accessToken
            let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token="+accessToken)
            
            let urlRequest = NSURLRequest(URL: url!)
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
                let image = UIImage(data: data)
                
                self.profilePictureView.image = image
                
                self.usernameLabel.text = name
                
            }
        } else {
            
            self.usernameLabel.text = PFUser.currentUser()!.username
            
        }
        

        scrollView.delegate = self
        scrollView.addSubview(profileView)
        scrollView.contentSize = CGSizeMake(0, 550)
        
        descriptions.removeAll(keepCapacity: true)
        usernames.removeAll(keepCapacity: true)
        imageFiles.removeAll(keepCapacity: true)
        bookGUIDs.removeAll(keepCapacity: true)
        realUsernames.removeAll(keepCapacity: true)
        
        var profileQuery = PFQuery(className: "BookPosting")
        
        if (isLinkedWithFB == false) {
        
            profileQuery.whereKey("username", equalTo: PFUser.currentUser()!.username!)
            profileQuery.findObjectsInBackgroundWithBlock {
            
                (objects , error) -> Void in
            
                if error == nil {
                
                    // The find succeeded.
                    // Do something with the found objects
                    if let objects = objects as? [PFObject] {
                    
                    
                    
                        for object in objects {
                        
                            if (object["imageFile"] != nil) {

                                descriptions.append(object["Description"] as! String)
                        
                                usernames.append(object["username"] as! String)
                        
                                imageFiles.append(object["imageFile"] as! PFFile)
                                
                                bookGUIDs.append(object["GUID"] as! String)
                                
                                realUsernames.append(object["realUsername"] as! String)
                                
                            }
                        
                            self.profileTableView.reloadData()
                        
                        }
                    
                    }
                
                } else {
                
                    // Log details of the failure
                    println("Error: \(error) \(error!.userInfo!)")
                
                }
            
            }
            
        } else {

            profileQuery.whereKey("username", equalTo: name)
            profileQuery.findObjectsInBackgroundWithBlock {
                
                (objects, error) -> Void in
                
                if error == nil {
                    
                    // The find succeeded.
                    // Do something with the found objects
                    if let objects = objects as? [PFObject] {
                        
                        
                        
                        for object in objects {
                            
                            if (object["imageFile"] != nil) {
                                
                                descriptions.append(object["Description"] as! String)
                                
                                usernames.append(object["username"] as! String)
                                
                                imageFiles.append(object["imageFile"] as! PFFile)
                                
                                bookGUIDs.append(object["GUID"] as! String)
                                
                                realUsernames.append(object["realUsername"] as! String)
                                
                            }
                            
                            self.profileTableView.reloadData()
                            
                        }
                        
                    }
                    
                } else {
                    
                    // Log details of the failure
                    println("Error: \(error) \(error!.userInfo!)")
                    
                }
                
            }
            
        }

        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            
            // delete the book from the array and the database
            
            
            var bookDeleteQuery = PFQuery(className: "BookPosting")
            
            bookDeleteQuery.whereKey("GUID", equalTo: bookGUIDs[indexPath.row])
            
            var books = bookDeleteQuery.findObjects() as! [PFObject]
            
            for book in books {
                
                book.delete()
                
            }
         
        }
        
   
        usernames.removeAtIndex(indexPath.row)
        descriptions.removeAtIndex(indexPath.row)
        imageFiles.removeAtIndex(indexPath.row)
        bookGUIDs.removeAtIndex(indexPath.row)
        
        self.profileTableView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return descriptions.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: bookCell = self.profileTableView.dequeueReusableCellWithIdentifier("profileCell") as! bookCell
        
        cell.profileBookDescription.text = descriptions[indexPath.row]
        cell.profileBookUsername.text = usernames[indexPath.row]
        
        imageFiles[indexPath.row].getDataInBackgroundWithBlock { (imageData, error) -> Void in
            
            if error == nil {
                
                var image = UIImage(data: imageData!)!
                
                cell.profileBookImage.image = image
                
            }
            
        }
        
        return cell
    }

    
}
