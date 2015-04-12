//
//  MailViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/30/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit



class MailViewController: UIViewController {

    @IBAction func backToMailVC(segue:UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        fromLabel.text = "From: \(fromUser)"
        messageText.text = message
        toUser = fromUser
        realFromUser = realFromUsernames[messageIndex]
        
        var messageQuery = PFQuery(className: "Message")
        
        messageQuery.whereKey("GUID", equalTo: GUID)
        
        var messages = messageQuery.findObjects() as [PFObject]
        
        
        for object in messages { // message is of PFObject type
            
            linkedId = object["linkedId"] as NSString
            object["readStatus"] = "yes"
            object.saveInBackground()
        }

    }
    

    @IBOutlet var fromLabel: UILabel!
    
    @IBOutlet var messageText: UITextView!
    
    @IBAction func reply(sender: AnyObject) {
        
        self.performSegueWithIdentifier("replySegue", sender: self)
        
    }
    
    @IBAction func deleteMessage(sender: AnyObject) {
        
        var messageQuery = PFQuery(className: "Message")
        
        messageQuery.whereKey("GUID", equalTo: GUID)
        
        var messages = messageQuery.findObjects() as [PFObject]
        
        for message in messages { // message is of PFObject type
            
            message.delete()
            
        }
        
        self.performSegueWithIdentifier("backToMailbox", sender: self)
        
    }
 
    
}
