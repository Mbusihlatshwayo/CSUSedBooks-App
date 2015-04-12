//
//  PeopleViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/19/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController, UITableViewDelegate {
    
    var users = ["Mitch", "Mbusi", "Rocio", "Ben", "Phyllis", "Nomi"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("Current view: PeopleViewController")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = users[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
    }

    
}
