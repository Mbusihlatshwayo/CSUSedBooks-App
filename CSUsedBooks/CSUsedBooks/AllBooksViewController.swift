//
//  AllBooksViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/21/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

var descriptions = [String]()
var usernames = [String]()
var images = [UIImage]()
var imageFiles = [PFFile]()

class AllBooksViewController: UITableViewController {
    

    @IBOutlet var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationBar.translucent = false
        
        var query = PFQuery(className:"BookPosting")
        //query.whereKey("playerName", equalTo:"Sean Plott")
        query.findObjectsInBackgroundWithBlock {
            
            (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if error == nil {
                
                // The find succeeded.
                println("Successfully retrieved \(objects.count) scores.")
                
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    
                    for object in objects {
                        
                        descriptions.append(object["Description"] as String)
                        
                        usernames.append(object["username"] as String)
                        
                        imageFiles.append(object["imageFile"] as PFFile)
                        
                        self.tableView.reloadData()
                        
                    }
                    
                }
                
            } else {
                
                // Log details of the failure
                println("Error: \(error) \(error.userInfo!)")
                
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return descriptions.count
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: bookCell = self.tableView.dequeueReusableCellWithIdentifier("cell1") as bookCell
        
        cell.bookDescription.text = descriptions[indexPath.row]
        cell.bookPosterUsername.text = usernames[indexPath.row]
        
        imageFiles[indexPath.row].getDataInBackgroundWithBlock { (imageData: NSData!, error: NSError!) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData)
                
                cell.bookImage.image = image 
                
            }
            
        }
        
        return cell
    }

}