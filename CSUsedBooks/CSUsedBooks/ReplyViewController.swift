//
//  ReplyViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/30/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {

    func displayAlert(title: String, error: String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func backToListViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBOutlet var toLabel: UILabel!
    
    @IBOutlet var messageTextView: UITextView!

    @IBAction func sendMessage(sender: AnyObject) {
        
        GUID = NSUUID().UUIDString
    
        var linkedQuerry = PFQuery(className: "Message")
        
        linkedQuerry.whereKey("GUID", equalTo: GUID)
        
        var messages = linkedQuerry.findObjects() as! [PFObject]
        
        for linkedMessage in messages { // message is of PFObject type
          
            //message["linkedId"] =
            
        }
        
        
        var message = PFObject(className: "Message")
        if (isLinkedWithFB) {
            
            message["FromUser"] = name
            message["Text"] = self.messageTextView.text
            message["ToUser"] = toUser
            message["realToUser"] = realFromUser
            message["realFromUser"] = PFUser.currentUser()!.username
            message["GUID"] = GUID
            message["linkedId"] = linkedId
            message["readStatus"] = "no"
        } else {
            
            message["FromUser"] = PFUser.currentUser()!.username
            message["Text"] = self.messageTextView.text
            message["ToUser"] = toUser
            message["realFromUser"] = PFUser.currentUser()!.username
            message["realToUser"] = realFromUser
            message["GUID"] = GUID
            message["linkedId"] = linkedId
            message["readStatus"] = "no"
        }
        

        
        message.saveInBackgroundWithBlock { (succes, error) -> Void in
            
            
            if succes == false {
                
   
                self.displayAlert("Your message could not be sent", error: "Please try again.")
                
            } else {

                self.messageTextView.text = ""
                
                self.displayAlert("Your message was sent!", error: "Succesful Send")
                
                var push = PFPush()
                
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
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        toLabel.text = fromUser
        
        messageTextView.becomeFirstResponder()
        
    }
    
    
    
}
