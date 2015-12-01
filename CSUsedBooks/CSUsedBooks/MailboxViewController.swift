//
//  MailboxViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/29/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

var messages = [String]()
var fromUsernames = [String]()
var GUIDArr = [String]()
var fromUser = ""
var realFromUser = ""
var message = ""
var messageIndex = Int()
var GUID = ""
var profilePicture = UIImage()
var realFromUsernames = [String]()
var subjectQuery = PFQuery(className: "Message")

class MailboxViewController: UIViewController , UITableViewDelegate{

    @IBOutlet var messageTableView: UITableView!
    
    @IBAction func backToMailViewController(segue:UIStoryboardSegue) {
        
    }
        
    override func viewDidLoad() {

        super.viewDidLoad()
        messages.removeAll(keepCapacity: true)
        fromUsernames.removeAll(keepCapacity: true)
        GUIDArr.removeAll(keepCapacity: true)
        realFromUsernames.removeAll(keepCapacity: true)
        
        if (isLinkedWithFB) {
            
            subjectQuery.whereKey("ToUser", equalTo: name)
            subjectQuery.orderByDescending("createdAt")
            
            subjectQuery.findObjectsInBackgroundWithBlock {
                
                (objects, error) -> Void in
                
                if error == nil {
                    
                    // The find succeeded.
                    // Do something with the found objects
                    if let objects = objects as? [PFObject] {
                        
                        for object in objects {
                            
                            GUIDArr.append(object["GUID"] as! String)
                            messages.append(object["Text"] as! String)
                            fromUsernames.append(object["FromUser"] as! String)
                            realFromUsernames.append(object["realFromUser"] as! String)
                            self.messageTableView.reloadData()
                            
                        }
                        
                    }
                    
                    
                } else {
                    
                    // Log details of the failure
                    print("Error: \(error) \(error!.userInfo)")
                    
                }
                
            }
            
        } else {
            
            subjectQuery.whereKey("ToUser", equalTo: PFUser.currentUser()!.username!)
            subjectQuery.orderByDescending("createdAt")
            subjectQuery.findObjectsInBackgroundWithBlock {
                
                (objects, error) -> Void in
                
                if error == nil {
                    
                    // The find succeeded.
                    // Do something with the found objects
                    if let objects = objects as? [PFObject] {
                        
                        for object in objects {
                            
                            GUIDArr.append(object["GUID"] as! String)
                            messages.append(object["Text"] as! String)
                            fromUsernames.append(object["FromUser"] as! String)
                            realFromUsernames.append(object["realFromUser"] as! String)
                            self.messageTableView.reloadData()
                            
                        }
                        
                    }
                    
                    
                } else {
                    
                    // Log details of the failure
                    print("Error: \(error) \(error!.userInfo)")
                    
                }
                
            }
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        messageIndex = indexPath.row
        self.messageTableView.deselectRowAtIndexPath(indexPath, animated: true)
        fromUser = fromUsernames[messageIndex]
        message = messages[messageIndex]
        GUID = GUIDArr[messageIndex]
        self.performSegueWithIdentifier("detailMessageSegue", sender: self)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:MessageCell = self.messageTableView.dequeueReusableCellWithIdentifier("messageCell") as! MessageCell
        
        cell.fromUsername.text = fromUsernames[indexPath.row]
        cell.messageText.text = messages[indexPath.row]
        
        return cell
        
    }
    
}
