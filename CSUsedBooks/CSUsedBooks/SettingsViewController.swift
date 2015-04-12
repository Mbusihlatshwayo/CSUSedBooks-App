//
//  SettingsViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 4/3/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

var didChangeProfilePicture: Bool = false
var profilePic: UIImage? = nil

class SettingsViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    @IBAction func changePicture(sender: AnyObject) {
        
            var image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            image.allowsEditing = false
            
            self.presentViewController(image, animated: true, completion: nil)
        
    }

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        didChangeProfilePicture = true
        
        NSUserDefaults.standardUserDefaults().setObject(UIImagePNGRepresentation(image), forKey: "profilePic")
        
        profilePic = image 
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
}
