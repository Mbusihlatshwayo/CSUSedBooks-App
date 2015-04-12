//
//  TableViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/25/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

var descriptions = [String]()
var usernames = [String]()
var images = [UIImage]()
var imageFiles = [PFFile]()
var bookGUIDs = [String]()
var selectedPhoto = UIImage()
var realUsernames = [String]()

class TableViewController: UIViewController, UITableViewDelegate {
    
    
    @IBAction func backToAllListingsViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func support(sender: AnyObject) {
        
        self.performSegueWithIdentifier("support", sender: self)
        
    }
    
    @IBOutlet var myNavigationBar: UINavigationBar!
    
    
    @IBOutlet var myTableView: UITableView!
    
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
        
        descriptions.removeAll(keepCapacity: true)
        usernames.removeAll(keepCapacity: true)
        imageFiles.removeAll(keepCapacity: true)
        bookGUIDs.removeAll(keepCapacity: true)
        realUsernames.removeAll(keepCapacity: true)
        realFromUsernames.removeAll(keepCapacity: true)
        
        var query = PFQuery(className:"BookPosting")
        //query.whereKey("playerName", equalTo:"Sean Plott")
        query.findObjectsInBackgroundWithBlock {
            
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
                            
                            linkedIdArr.append(object.objectId! as String)
                            
                            realFromUsernames.append(object["realUsername"] as! String)
                            
                        }
                        
                        self.myTableView.reloadData()
                        
                    }
                    
                }
                
            } else {
                
                // Log details of the failure
                println("Error: \(error) \(error!.userInfo!)")
                
            }
        }

        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return descriptions.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
        
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: bookCell = self.myTableView.dequeueReusableCellWithIdentifier("prototype") as! bookCell
        
        cell.allBooksDescription.text = descriptions[indexPath.row]
        cell.allBooksUsername.text = usernames[indexPath.row]
        
        imageFiles[indexPath.row].getDataInBackgroundWithBlock { (imageData, error) -> Void in
            
            if error == nil {
                
                var image = UIImage(data: imageData!)!
                
                cell.allBooksImage.image = image
                
            }
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selectedIndex = indexPath.row
        
        imageFiles[selectedIndex].getDataInBackgroundWithBlock { (imageData, error) -> Void in
            
            if (error == nil) {
                
                selectedPhoto = UIImage(data: imageData!)!
                
            }
            
        }
        self.performSegueWithIdentifier("secondDetailSegue", sender: self)

    }
    
}
    
    


