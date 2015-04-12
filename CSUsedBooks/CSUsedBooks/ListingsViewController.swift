//
//  ListingsViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/21/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

class ListingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("All Listings view controller")
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
    }
    
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let bookCell: BookCell = self.tableView.dequeueReusableCellWithIdentifier("myCell") as BookCell
    
    return bookCell
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    println(indexPath.row)
    }


    
    
}
