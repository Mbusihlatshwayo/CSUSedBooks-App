//
//  PhotoViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/28/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

var pushUser = ""

var toUser = ""

var linkedId = ""

var realtouser = ""

class PhotoViewController: UIViewController {

    @IBOutlet var usernameLabel: UILabel!
    
    @IBOutlet var bookPhoto: UIImageView!
    
    @IBOutlet var bookDescription: UILabel!
    
    @IBAction func contactSeller(sender: AnyObject) {
        
        self.performSegueWithIdentifier("messageSegue", sender: self)
        
    }
    
    @IBAction func backToBookViewController(segue:UIStoryboardSegue) {
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        bookDescription.text = descriptions[selectedIndex]
        usernameLabel.text = usernames[selectedIndex]
        pushUser = realUsernames[selectedIndex]
        linkedId = linkedIdArr[selectedIndex]
        realFromUser = realFromUsernames[selectedIndex]
        
        toUser = usernameLabel.text!
        realtouser = realUsernames[selectedIndex]
        imageFiles[selectedIndex].getDataInBackgroundWithBlock { (imageData, error) -> Void in
            
            
            if (error == nil) {
                
                selectedPhoto = UIImage(data: imageData!)!
                
                let image = UIImage(data: imageData!)
                
                self.bookPhoto.image = image
                
            } else {
                
                self.bookPhoto.image = UIImage(named: "book1.png")
                
            }
            
        }
        
    }
    
}
