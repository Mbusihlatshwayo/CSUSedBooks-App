//
//  MessageViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/29/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    func displayAlert(title: String, error: String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    
    @IBOutlet var toUserLabel: UILabel!

    @IBOutlet var messageTextView: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        messageTextView.becomeFirstResponder()
        messageTextView.text = "Hi I am interested in your book"
        toUserLabel.text = "To: \(toUser)"

    }
  
    
    @IBAction func sendMessage(sender: AnyObject) {
        
        GUID = NSUUID().UUIDString
        
        var message = PFObject(className: "Message")
        
        if (isLinkedWithFB) {
            
            message["FromUser"] = name
            message["Text"] = self.messageTextView.text
            message["ToUser"] = toUser
            message["realFromUser"] = PFUser.currentUser().username
            message["GUID"] = GUID
            message["linkedId"] = linkedId
            message["realToUser"] = realtouser
            message["readStatus"] = "no"
            
        } else {
            
            message["FromUser"] = PFUser.currentUser().username
            message["Text"] = self.messageTextView.text
            message["ToUser"] = toUser
            message["realFromUser"] = PFUser.currentUser().username
            message["GUID"] = GUID
            message["linkedId"] = linkedId
            message["realToUser"] = realtouser
            message["readStatus"] = "no"
        }
        
        message.saveInBackgroundWithBlock { (succes: Bool!, error: NSError!) -> Void in
            
            
            if succes == false {
                
  
                self.displayAlert("Your message could not be sent", error: "Message Failed To Send")
                
            } else {
                

                self.messageTextView.text = ""
                
                self.displayAlert("Your message was sent!", error: "Succesful Send")
                
                var push = PFPush()
                
                                // Send a notification to all devices subscribed to the "Giants" channel.
                
                let data = [
                    "alert" : "You have a new message check your mailbox!",
                    "badge" : "increment"
                ]
            
                push.setChannel(realFromUser)
                push.setData(data)
                push.sendPushInBackground()

            }
            
        }
        
    }
    
}
