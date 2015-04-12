//
//  PeopleViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/19/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    @IBOutlet var bookImage: UIImageView!
    
    @IBAction func choseImage(sender: AnyObject) {
    }
    
    
    @IBAction func postListing(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("Current view: PeopleViewController")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
