//
//  AllListingsViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/21/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

class AllListingsViewController: UITableViewController , UITableViewDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let bookCell: BookPostingCell = self.tableView.dequeueReusableCellWithIdentifier("BookCell") as BookPostingCell
        
        bookCell.posterUsername.text = "MbusiH"
        bookCell.postedBookImage.image = UIImage(named: "iosbookimage1.png")
        bookCell.bookDescription.text = "iOS development book $30"
        
        return bookCell
    }
    
}
