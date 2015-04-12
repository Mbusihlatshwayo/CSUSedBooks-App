//
//  SubjectViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/23/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

class SubjectViewController: UIViewController {

    @IBOutlet var navigationBarTitle: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("Subject view controller")
        
        self.navigationBarTitle.topItem?.title = "\(selectedSubject)"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: bookCell = tableView.dequeueReusableCellWithIdentifier("booksCells") as bookCell
        
        return cell
    }
    
    
    
}
