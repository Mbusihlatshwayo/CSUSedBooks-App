//
//  EditProfileViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/30/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        profilePic.image = image
        profilePicture = image
    }
    
    
    @IBAction func pickImage(sender: AnyObject) {
        
        println("pick image pressed")
        
        
        profileImage.delegate = self
        profileImage.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        profileImage.allowsEditing = false
        
        self.presentViewController(profileImage, animated: true, completion: nil)
    }
    
    @IBOutlet var profilePic: UIImageView!
    
}
