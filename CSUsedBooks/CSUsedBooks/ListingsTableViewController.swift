//
//  ListingsTableViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/18/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

class ListingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        println(PFUser.currentUser())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
